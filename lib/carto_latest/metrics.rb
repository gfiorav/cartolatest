module CartoLatest
  class Metrics
    def initialize
      @keen = Keen::Client.new(project_id: Rails.configuration.keen[:project_id],
                               read_key: Rails.configuration.keen[:read_key])
    end

    def latest_published
      @keen.extraction('Published map', timeframe: 'this_2_days')
    end
  end
end
