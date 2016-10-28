require 'anemone/http'

module Anemone
  class Tentacle

    #
    # Create a new Tentacle
    #
    def initialize(link_queue, page_queue, opts = {}, robots)
      @link_queue = link_queue
      @page_queue = page_queue
      @http = Anemone::HTTP.new(opts)
      @opts = opts
      @robots = robots
    end

    #
    # Gets links from @link_queue, and returns the fetched
    # Page objects into @page_queue
    #
    def run
      loop do
        link, referer, depth = @link_queue.deq

        break if link == :END

        @http.fetch_pages(link, referer, depth).each { |page| @page_queue << page }

        delay(link)
      end
    end

    private

    def delay(link)
      if @opts[:delay] > 0
        sleep @opts[:delay]
      else
        if @robots
          robots_delay = @robots.delay(link)
          sleep robots_delay if robots_delay
        end
      end
    end

  end
end
