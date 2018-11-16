require 'cgi'

module Genba
  module Util
    def self.log_error(message, data = {})
      if !Genba.logger.nil? ||
        !Genba.log_level.nil? && Genba.log_level <= Genba::LEVEL_ERROR
        log_internal(message, data, color: :cyan,
                                    level: Genba::LEVEL_ERROR, logger: Genba.logger, out: $stderr)
      end
    end

    def self.log_info(message, data = {})
      if !Genba.logger.nil? ||
        !Genba.log_level.nil? && Genba.log_level <= Genba::LEVEL_INFO
        log_internal(message, data, color: :cyan,
                                    level: Genba::LEVEL_INFO, logger: Genba.logger, out: $stdout)
      end
    end

    def self.log_debug(message, data = {})
      if !Genba.logger.nil? ||
        !Genba.log_level.nil? && Genba.log_level <= Genba::LEVEL_DEBUG
        log_internal(message, data, color: :blue,
                                    level: Genba::LEVEL_DEBUG, logger: Genba.logger, out: $stdout)
      end
    end

    COLOR_CODES = {
      black:   0, light_black:   60,
      red:     1, light_red:     61,
      green:   2, light_green:   62,
      yellow:  3, light_yellow:  63,
      blue:    4, light_blue:    64,
      magenta: 5, light_magenta: 65,
      cyan:    6, light_cyan:    66,
      white:   7, light_white:   67,
      default: 9,
    }.freeze
    private_constant :COLOR_CODES

    # Uses an ANSI escape code to colorize text if it's going to be sent to a
    # TTY.
    def self.colorize(val, color, isatty)
      return val unless isatty

      mode = 0 # default
      foreground = 30 + COLOR_CODES.fetch(color)
      background = 40 + COLOR_CODES.fetch(:default)

      "\033[#{mode};#{foreground};#{background}m#{val}\033[0m"
    end
    private_class_method :colorize

    # Turns an integer log level into a printable name.
    def self.level_name(level)
      case level
      when LEVEL_DEBUG then 'debug'
      when LEVEL_ERROR then 'error'
      when LEVEL_INFO  then 'info'
      else level
      end
    end
    private_class_method :level_name

    # TODO: Make these named required arguments when we drop support for Ruby
    # 2.0.
    def self.log_internal(message, data = {}, color: nil, level: nil, logger: nil, out: nil)
      data_str = data.reject { |_k, v| v.nil? }
                     .map do |(k, v)|
        format("%s=%s", colorize(k, color, logger.nil? && !out.nil? && out.isatty), wrap_logfmt_value(v))
      end.join(' ')

      if !logger.nil?
        # the library's log levels are mapped to the same values as the
        # standard library's logger
        logger.log(level, message)
      elsif out.isatty
        out.puts format("%s %s %s", colorize(level_name(level)[0, 4].upcase, color, out.isatty), message, data_str)
      else
        out.puts format("message=%s level=%s %s", wrap_logfmt_value(message), level_name(level), data_str)
      end
    end
    private_class_method :log_internal

    # Wraps a value in double quotes if it looks sufficiently complex so that
    # it can be read by logfmt parsers.
    def self.wrap_logfmt_value(val)
      # If value is any kind of number, just allow it to be formatted directly
      # to a string (this will handle integers or floats).
      return val if val.is_a?(Numeric)

      # Hopefully val is a string, but protect in case it's not.
      val = val.to_s

      if %r{[^\w\-/]} =~ val
        # If the string contains any special characters, escape any double
        # quotes it has, remove newlines, and wrap the whole thing in quotes.
        format(%("%s"), val.gsub('"', '\"').delete("\n"))
      else
        # Otherwise use the basic value if it looks like a standard set of
        # characters (and allow a few special characters like hyphens, and
        # slashes)
        val
      end
    end
    private_class_method :wrap_logfmt_value
  end
end
