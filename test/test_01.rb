# test_01.rb

require_relative '../lib/gds-data-validation'

require 'minitest/autorun'

class TestGdsDataValidation < Minitest::Test

  require_relative 'defs/testcases.rb'

  def setup
  end

  def test_schemas
    puts "Test schemas"
    puts "============"

    TestCases.each_with_index do |testcase,idx|

      schemaSpec, subTestcases = testcase

      puts "--- idx: #{idx}"
      puts schemaSpec
      puts "--"

      schemaParsingError = false
      validation = nil

      begin
        validation = GdsDataValidation.create( schemaSpec )

      rescue Exception => e
        puts "Error:Exception: #{e.inspect}"
        schemaParsingError = true
      end

      assert_equal schemaParsingError, false

      subTestcases[:true].each do |data|
        validation_res = validation.check( data )

        puts "#{data.inspect}"
        puts "  -> #{validation_res}"
        assert_equal validation_res, true
      end

      subTestcases[:false].each do |data|
        validation_res = validation.check( data )

        puts "#{data.inspect}"
        puts "  -> #{validation_res}"
        assert_equal validation_res, false
      end

    end
  end

end
