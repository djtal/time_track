require "time_track/version"
require "chronic"
require "thor"
require "dbus"
require "time"

module TimeTrack

  class CLI < Thor

    desc "resume", "list time per project during the given"
    method_option :from, :type => :string, :desc => "begining of the report period", :required => true
    method_option :to, :type  => :string, :desc => "end of the report period"
    def resume
      from_date = Chronic.parse(options[:from])
      to_date = Chronic.parse(options[:to]) || Time.now
      facts = get_facts(from_date, to_date)
      data = facts.inject({}) do |acc, fact|
        acc[fact[:project]] ||= 0
        acc[fact[:project]] += fact[:elapsed]
        acc
      end
      puts "Report or period #{from_date.strftime("%d/%m/%Y")} -> #{to_date.strftime("%d/%m/%Y")}"
      data.each do |project, elapsed|
        puts "#{project} = #{Time.at(elapsed).strftime("%H:%M")}"
      end
    end

    private

    def get_facts(from_date, to_date)
      setup unless @hamster
      facts = @hamster.GetFacts(from_date.to_i, to_date.to_i, '')[0]
      facts.map { |f| parse_facts f}
    end

    def setup
      bus = DBus::SessionBus.instance

      hamster_service = bus.service("org.gnome.Hamster")
      @hamster = hamster_service.object('/org/gnome/Hamster')
      @hamster.introspect
      @hamster.default_iface = 'org.gnome.Hamster'
    end

    # Return a hash containing all fact data in a better ruby form
    # [131, 1360752720, 1360757835, "", "FIX homepage et porduit coup de coeur", 45, "Cherriz", ["bugs"], 1360713600, 5115]
    #
    def parse_facts(fact_data)
      fact = {}
      fact[:hamster_id] = fact_data[0]
      fact[:start_time] = Time.at(fact_data[1])
      fact[:end_time] = Time.at(fact_data[2])
      fact[:description] = fact_data[3]
      fact[:name] = fact_data[4]
      fact[:project] = fact_data[6]
      fact[:tags] = fact_data[7]
      fact[:date] = Time.at(fact_data[8])
      fact[:elapsed] = fact[:end_time] - fact[:start_time]
      fact
    end

  end

end
