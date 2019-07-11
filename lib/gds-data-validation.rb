# gds-data-validation.rb

# You will find further information here:  https://urasepandia.de/gds-data-validation.html

require_relative 'gds-data-validation/version.rb'
require_relative 'gds-data-validation/lng_gds_check.rb'
require_relative 'gds-data-validation/validation_generator.rb'

class GdsDataValidation

  class << self

    # create an data validation class which is checking incoming data against a specified schema definition
    #
    # @param schema_definition [String] the schema definition to be used for data validation
    #
    # @return [Class] anonymous class for data validation
    #
    # @example
    #   require 'gds-data-validaion'
    #
    #   dataValidation = GdsDataValidation.create( <<-EOS )
    #   schema = @t_int
    #   EOS
    #
    #   dataValidation.check( 10 )    # => true
    #   dataValidation.check( "a" )   # => false
    def create( schema_definition )
      vcg = ValidationCheckerGenerator.new
      vcg.generate( LDLgeneratedLanguage::Language_gds_check.parse( schema_definition ) )
    end

    # create an data validation class which is checking incoming data against a specified schema definition stored in a file
    #
    # @param file_name [String] file name, this file contains the schema definition
    #
    # @return [Class] anonymous class for data validation
    def create_from_file( file_name )
      vcg = ValidationCheckerGenerator.new
      vcg.generate( LDLgeneratedLanguage::Language_gds_check.parse( File.read( file_name ) ) )
    end

  end

end
