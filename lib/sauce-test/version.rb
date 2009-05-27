module SauceTest # :nodoc:
  module VERSION # :nodoc:

    MAJOR  = 0
    MINOR  = 1
    TINY   = 0

    STRING = [MAJOR, MINOR, TINY].compact.join('.')

    SUMMARY = "sauce_test #{STRING}"

  end
end
