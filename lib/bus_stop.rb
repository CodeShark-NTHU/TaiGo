# frozen_string_literal: false

module PublicTransporation
  # Provides access to bus stop data
  class BusStop
    def initialize(data)
      @stop = data
    end

    def uid
      @stop['StopUID']
    end

    def authority_id
      @stop['AuthorityID']
    end

    def stop_name_ch
      @stop['StopName']['Zh_tw']
    end

    def stop_name_en
      @stop['StopName']['En']
    end

    def stop_latitude
      @stop['StopPosition']['PositionLat']
    end

    def stop_longitude
      @stop['StopPosition']['PositionLon']
    end

    def stop_address
      @stop['StopAddress']
    end
  end
end
