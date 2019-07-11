# validation_generator.rb

# ATTENTION: this file is generated

require 'forwardable'

class GdsDataValidation

  class ValidationCheckerGenerator

    class SourceGenerator

      def initialize
        @resultString = ""
        @indentLevel = 0
      end

      def indent
        @indentLevel += 1
      end

      def unindent
        @indentLevel -= 1  if @indentLevel > 0
      end

      def add( str )
        @resultString << str
      end

      def add_line( str )
        @resultString << " "*(@indentLevel * 2) + str << "\n"
      end

      def begin_line( str )
        @resultString << " "*(@indentLevel * 2) + str
      end

      def end_line( str )
        @resultString << str << "\n"
      end

      def new_line
        @resultString << "\n"
      end

      def result
        @resultString
      end

      def reset
        @resultString = ""
      end

    end

    extend Forwardable
    def_delegators :@scgen, :add, :add_line, :begin_line, :end_line, :new_line, :indent, :unindent, :result, :reset

    def initialize
      @scgen = SourceGenerator.new
    end

    def generate( appliedGrammar )
      reset
      _gen_main( appliedGrammar )

      create_class
    end

    private

    def create_class
      Class.new.tap{ |x| x.class_eval( result ) }
    end


    def _gen_main( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        if label
          case label
          when "before"
            indent
            add_line "class << self"
            new_line
            indent
          when "after"
            unindent
            new_line
            add_line "end"
            unindent
          when "check_method"
            add_line "def check( value )"
            indent
            _gen_ruledefinition( struct.first, "callfirstrule" )
            unindent
            add_line "end"
          end
        else
          unless label || params
            _gen_main( struct, "before" )
            _gen_main( struct, "check_method" )
            struct.each do |subval|
              _gen_ruledefinition( subval, nil, nil )
            end
            _gen_main( struct, "after" )
          end
        end
      end
    end

    def _gen_ruledefinition( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :name ) && struct.has_key?( :ruledefinition ) )
        if label
          case label
          when "callfirstrule"
            add_line "check_#{struct[:name]}( value )"
          end
        else
          unless label || params
            new_line
            add_line "def check_#{struct[:name]}( value )"
            indent
            _gen_alternatives( struct[:ruledefinition], nil, nil )
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_alternatives( struct, label = nil, params = nil )
      if struct.is_a?( Array ) && struct.length() == 1
        unless label || params
          struct.each do |subval|
            _gen_alternative( subval, nil, nil )
          end
        end
      elsif struct.is_a?( Array ) && struct.length() >= 2
        unless label || params
          add_line "clauseRule = false"
          struct.each do |subval|
            _gen_alternative_clause( subval, nil, nil )
          end
          begin_line ""
          add "unless"
          end_line( " clauseRule" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          add_line "return true"
        end
      end
    end

    def _gen_alternative_clause( struct, label = nil, params = nil )
      if true #  :name
        unless label || params
          add_line "unless clauseRule"
          indent
          add_line "clauseRule = lambda do"
          indent
          _gen_alternative( struct, nil, nil )
          unindent
          add_line "end.()"
          unindent
          add_line "end"
        end
      end
    end

    def _gen_alternative( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :hashdef ) && struct.has_key?( :strict ) && struct[:strict] == :strict )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          add_line "unless ( value.is_a?( Hash ) )"
          indent
          add_line "return false"
          unindent
          add_line "end"
          begin_line "unless ( value.keys - %i( "
          struct[:hashdef].each do |subval|
            _gen_keyvaluedef( subval, "output_key" )
          end
          end_line( ") ).empty?" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          struct[:hashdef].each do |subval|
            _gen_keyvaluedef( subval, nil, nil )
          end
          add_line "return true"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :hashdef ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          add_line "unless ( value.is_a?( Hash ) )"
          indent
          add_line "return false"
          unindent
          add_line "end"
          struct[:hashdef].each do |subval|
            _gen_keyvaluedef( subval, nil, nil )
          end
          add_line "return true"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :arraydef ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          add_line "unless value.is_a?( Array )"
          indent
          add_line "return false"
          unindent
          add_line "end"
          _gen_arraydef( struct[:arraydef], nil, ["value"] )
          add_line "return true"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :subruledef ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          begin_line "unless check_"
          _gen_subruledef( struct[:subruledef], "therulename", nil )
          end_line( "( value )" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          add_line "return true"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :typedef ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          begin_line ""
          _gen_notop( struct[:typedef], nil, nil )
          add " ( "
          _gen_typedef( struct[:typedef], "typecheck", ["value"] )
          end_line( " )" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          _gen_maybe2( struct[:typedef], nil, ["value"] )
          add_line "return true"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :basicvaluedef ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          _gen_basicvaluedef( struct[:basicvaluedef], nil, ["value"] )
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valdefdisjunct ) )
        unless label || params
          _gen_maybe3( struct, nil, ["value"] )
          add_line "clause = false"
          struct[:valdefdisjunct].each do |subval|
            _gen_disjunction( subval, nil, ["value"] )
          end
          begin_line ""
          _gen_notop( struct, nil, nil )
          end_line( " clause" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          add_line "return true"
        end
      end
    end

    def _gen_basicvaluedef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_true && struct.has_key?( :value ) )
        if label
          case label
          when "thevalue"
            add "true"
          end
        elsif params
          if params.length == 1
            add_line "unless #{params[0]} == true"
            indent
            add_line "return false"
            unindent
            add_line "end"
            add_line "return true"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_false && struct.has_key?( :value ) )
        if label
          case label
          when "thevalue"
            add "false"
          end
        elsif params
          if params.length == 1
            add_line "unless #{params[0]} == false"
            indent
            add_line "return false"
            unindent
            add_line "end"
            add_line "return true"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_nil && struct.has_key?( :value ) )
        if label
          case label
          when "thevalue"
            add "nil"
          end
        elsif params
          if params.length == 1
            add_line "unless #{params[0]} == nil"
            indent
            add_line "return false"
            unindent
            add_line "end"
            add_line "return true"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :value ) )
        if label
          case label
          when "thevalue"
            add "#{struct[:value].inspect}"
          end
        elsif params
          if params.length == 1
            add_line "unless #{params[0]} == #{struct[:value].inspect}"
            indent
            add_line "return false"
            unindent
            add_line "end"
            add_line "return true"
          end
        end
      end
    end

    def _gen_maybe( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :maybe ) && struct[:maybe] == :maybe )
        if params
          if params.length == 1
            add "#{params[0]}.nil? || "
          end
        end
      end
    end

    def _gen_maybe2( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :maybe ) && struct[:maybe] == :maybe )
        if params
          if params.length == 1
            add_line "unless #{params[0]}.nil?"
            indent
            _gen_typedef( struct, nil, ["value"] )
            unindent
            add_line "end"
          end
        end
      elsif true
        if params
          if params.length == 1
            _gen_typedef( struct, nil, ["value"] )
          end
        end
      end
    end

    def _gen_maybe3( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :maybe ) && struct[:maybe] == :maybe )
        if label
          case label
          when "condition"
            if params
              if params.length == 1
                add "#{params[0]}.nil? || "
              end
            end
          when "only_begin"
            if params
              if params.length == 1
                add_line "unless #{params[0]}.nil?"
                indent
              end
            end
          when "only_end"
            unindent
            add_line "end"
          when "disjunct"
            if params
              if params.length == 1
                add_line "clause = #{params[0]}.nil?"
              end
            end
          end
        elsif params
          if params.length == 1
            add_line "if #{params[0]}.nil?"
            indent
            add_line "return true"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_disjunction( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :typedef ) )
        if params
          if params.length == 1
            add_line "unless clause"
            indent
            add_line "clause = lambda do"
            indent
            begin_line ""
            _gen_notop( struct[:typedef], nil, nil )
            add " ( "
            _gen_typedef( struct[:typedef], "typecheck", ["#{params[0]}"] )
            end_line( " )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
            _gen_typedef( struct[:typedef], nil, ["#{params[0]}"] )
            add_line "return true"
            unindent
            add_line "end.()"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :basicvaluedef ) )
        if params
          if params.length == 1
            add_line "unless clause"
            indent
            add_line "clause = lambda do"
            indent
            _gen_maybe3( struct, nil, ["#{params[0]}"] )
            _gen_basicvaluedef( struct[:basicvaluedef], nil, ["#{params[0]}"] )
            unindent
            add_line "end.()"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_keyvaluedef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :keyvaluedef ) )
        if label
          case label
          when "output_key"
            _gen_keyvaluedef1( struct[:keyvaluedef], "output_key", nil )
          end
        else
          unless label || params
            _gen_keyvaluedef1( struct[:keyvaluedef], nil, nil )
          end
        end
      end
    end

    def _gen_arraydef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :rulename ) && struct.has_key?( :sizespec ) )
        if params
          if params.length == 1
            _gen_sizespec( struct[:sizespec], nil, ["#{params[0]}"] )
            add_line "unless #{params[0]}.all? { |e| check_#{struct[:rulename]}( e ) }"
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_keyvaluedef1( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :key ) && struct.has_key?( :value ) && struct.has_key?( :optional ) && struct[:optional] == :optional )
        if label
          case label
          when "output_key"
            add "#{struct[:key]} "
          end
        else
          unless label || params
            add_line "if value.has_key?( #{struct[:key].inspect} )"
            indent
            add_line "v = value.fetch( #{struct[:key].inspect} )"
            _gen_valuedef( struct[:value], nil, nil )
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :key ) && struct.has_key?( :value ) )
        if label
          case label
          when "output_key"
            add "#{struct[:key]} "
          end
        else
          unless label || params
            add_line "unless value.has_key?( #{struct[:key].inspect} )"
            indent
            add_line "return false"
            unindent
            add_line "end"
            add_line "v = value.fetch( #{struct[:key].inspect} )"
            _gen_valuedef( struct[:value], nil, nil )
          end
        end
      end
    end

    def _gen_valuedef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :basicvaluedef ) )
        unless label || params
          begin_line "unless "
          _gen_maybe3( struct, "condition", ["v"] )
          add "v == "
          _gen_basicvaluedef( struct[:basicvaluedef], "thevalue", nil )
          end_line( "" )
          indent
          add_line "return false"
          unindent
          add_line "end"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :typedef ) )
        unless label || params
          begin_line "unless "
          _gen_maybe3( struct, "condition", ["v"] )
          _gen_notop( struct[:typedef], "boolop", nil )
          add "( "
          _gen_typedef( struct[:typedef], "typecheck", ["v"] )
          end_line( " )" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          _gen_maybe3( struct, "only_begin", ["v"] )
          _gen_typedef( struct[:typedef], nil, ["v"] )
          _gen_maybe3( struct, "only_end", nil )
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :arraydef ) )
        unless label || params
          begin_line "unless "
          _gen_maybe3( struct, "condition", ["v"] )
          end_line( "v.is_a?( Array )" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          _gen_maybe3( struct, "only_begin", ["v"] )
          _gen_arraydef( struct[:arraydef], nil, ["v"] )
          _gen_maybe3( struct, "only_end", nil )
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :subruledef ) )
        unless label || params
          begin_line "unless "
          _gen_maybe3( struct, "condition", ["v"] )
          add "check_"
          _gen_subruledef( struct[:subruledef], "therulename", nil )
          end_line( "( v )" )
          indent
          add_line "return false"
          unindent
          add_line "end"
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valdefdisjunct ) )
        unless label || params
          add_line "clause = false"
          _gen_maybe3( struct, "disjunct", ["v"] )
          struct[:valdefdisjunct].each do |subval|
            _gen_disjunction( subval, nil, ["v"] )
          end
          _gen_maybe3( struct, "only_begin", ["v"] )
          begin_line ""
          _gen_notop( struct, nil, nil )
          end_line( " clause" )
          indent
          add_line "return false"
          unindent
          add_line "end"
          _gen_maybe3( struct, "only_end", nil )
        end
      end
    end

    def _gen_sizespec( struct, label = nil, params = nil )
      if ( struct.is_a?( Symbol ) && struct == :* )
        if params
          if params.length == 1
          end
        end
      elsif ( struct.is_a?( Symbol ) && struct == :+ )
        if params
          if params.length == 1
            add_line "unless #{params[0]}.size() >= 1"
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif true
        if params
          if params.length == 1
            _gen_minmaxspec( struct, nil, ["#{params[0]}"".size()"] )
          end
        end
      end
    end

    def _gen_subruledef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :rulename ) )
        if label
          case label
          when "therulename"
            add "#{struct[:rulename]}"
          end
        end
      end
    end

    def _gen_typedef( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_string && struct.has_key?( :valuespecs ) )
        if label
          case label
          when "thetype"
            unless params
              add "String"
            end
            if params
              if params.length == 1
                add "String # #{params[0]}"
              end
              if params.length == 2
                add "String # #{params[0]} and #{params[1]}"
              end
            end
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        elsif params
          if params.length == 1
            struct[:valuespecs].each do |subval|
              _gen_stringvaluespec( subval, nil, ["#{params[0]}"] )
            end
          end
          if params.length == 2
            struct[:valuespecs].each do |subval|
              _gen_stringvaluespec( subval, nil, ["#{params[1]}"" - ""#{params[0]}"] )
            end
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_string )
        if label
          case label
          when "thetype"
            add "String"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_int && struct.has_key?( :valuespecs ) )
        if label
          case label
          when "thetype"
            add "Integer"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        elsif params
          if params.length == 1
            _gen_intvaluespecs( struct[:valuespecs], nil, ["#{params[0]}"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_int )
        if label
          case label
          when "thetype"
            add "Integer"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_float && struct.has_key?( :valuespecs ) )
        if label
          case label
          when "thetype"
            add "Float"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        elsif params
          if params.length == 1
            _gen_floatvaluespecs( struct[:valuespecs], nil, ["#{params[0]}"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_float )
        if label
          case label
          when "thetype"
            add "Float"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_nil )
        if label
          case label
          when "thetype"
            add "NilClass"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_numeric )
        if label
          case label
          when "thetype"
            add "Numeric"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_symbol && struct.has_key?( :valuespecs ) )
        if label
          case label
          when "thetype"
            add "Symbol"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        elsif params
          if params.length == 1
            _gen_symbolvaluespecs( struct[:valuespecs], nil, ["#{params[0]}"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_symbol )
        if label
          case label
          when "thetype"
            add "Symbol"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_true )
        if label
          case label
          when "thetype"
            add "TrueClass"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_false )
        if label
          case label
          when "thetype"
            add "FalseClass"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_bool )
        if label
          case label
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( TrueClass ) || #{params[0]}.is_a?( FalseClass )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :type ) && struct[:type] == :t_any )
        if label
          case label
          when "thetype"
            add "Object"
          when "typecheck"
            if params
              if params.length == 1
                add "#{params[0]}.is_a?( "
                _gen_typedef( struct, "thetype" )
                add " )"
              end
            end
          end
        else
          unless label || params
            add ""
          end
        end
      end
    end

    def _gen_intvaluespecs( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        if params
          if params.length == 1
            struct.each do |subval|
              _gen_intvaluespec( subval, nil, ["#{params[0]}"] )
            end
          end
        end
      end
    end

    def _gen_intvaluespec( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :even )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]}.even?" )
            indent
            add_line "return false"
            unindent
            add_line "end"
            _gen_minmaxspec( struct, nil, ["#{params[0]}"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :odd )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]}.odd?" )
            indent
            add_line "return false"
            unindent
            add_line "end"
            _gen_minmaxspec( struct, nil, ["#{params[0]}"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :eql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} == #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :neql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} != #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valuelist ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{struct[:valuelist].inspect}.include?( #{params[0]} )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif true
        if params
          if params.length == 1
            _gen_minmaxspec( struct, nil, ["#{params[0]}"] )
          end
        end
      end
    end

    def _gen_stringvaluespecs( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        if params
          if params.length == 1
            struct.each do |subval|
              _gen_stringvaluespec( subval, nil, ["#{params[0]}"] )
            end
          end
        end
      end
    end

    def _gen_stringvaluespec( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :eql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} == #{struct[:val].inspect}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :neql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} != #{struct[:val].inspect}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valuelist ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{struct[:valuelist].inspect}.include?( #{params[0]} )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :empty )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]}.empty?" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :something )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " ! #{params[0]}.empty?" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :blank )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]}.empty? || #{params[0]}.match( /\\A[[:space:]]*\\z/ )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :present )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " ! ( #{params[0]}.empty? || #{params[0]}.match( /\\A[[:space:]]*\\z/ ) )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :length )
        if params
          if params.length == 1
            add_line "l = #{params[0]}.length"
            _gen_minmaxspec( struct, nil, ["l"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :regexp && struct.has_key?( :regexp ) && struct.has_key?( :options ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            add " #{params[0]}.match( /#{struct[:regexp]}/"
            _gen_regexp_options( struct[:options], nil, nil )
            end_line( " )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_regexp_options( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        unless label || params
          struct.each do |subval|
            _gen_regexp_option( subval, nil, nil )
          end
        end
      end
    end

    def _gen_regexp_option( struct, label = nil, params = nil )
      if ( struct.is_a?( Symbol ) && struct == :i )
        unless label || params
          add "i"
        end
      end
    end

    def _gen_floatvaluespecs( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        if params
          if params.length == 1
            struct.each do |subval|
              _gen_floatvaluespec( subval, nil, ["#{params[0]}"] )
            end
          end
        end
      end
    end

    def _gen_floatvaluespec( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :eql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} == #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :neql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} != #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valuelist ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{struct[:valuelist].inspect}.include?( #{params[0]} )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif true
        if params
          if params.length == 1
            _gen_minmaxspec( struct, nil, ["#{params[0]}"] )
          end
        end
      end
    end

    def _gen_symbolvaluespecs( struct, label = nil, params = nil )
      if struct.is_a?( Array )
        if params
          if params.length == 1
            struct.each do |subval|
              _gen_symbolvaluespec( subval, nil, ["#{params[0]}"] )
            end
          end
        end
      end
    end

    def _gen_symbolvaluespec( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :eql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} == #{struct[:val].inspect}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :neql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} != #{struct[:val].inspect}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :valuelist ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{struct[:valuelist].inspect}.include?( #{params[0]} )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :length )
        if params
          if params.length == 1
            add_line "l = #{params[0]}.length"
            _gen_minmaxspec( struct, nil, ["l"] )
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :spec ) && struct[:spec] == :regexp && struct.has_key?( :regexp ) && struct.has_key?( :options ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            add " #{params[0]}.match( /#{struct[:regexp]}/"
            _gen_regexp_options( struct[:options], nil, nil )
            end_line( " )" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_minmaxspec( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :relop ) && struct[:relop] == :eql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} == #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :relop ) && struct[:relop] == :neql && struct.has_key?( :val ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} != #{struct[:val]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :minspec ) && struct.has_key?( :maxspec ) && struct.has_key?( :min ) && struct.has_key?( :max ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            add " #{params[0]} "
            _gen_relationalop( struct[:minspec], nil, nil )
            add " #{struct[:min]} && #{params[0]} "
            _gen_relationalop( struct[:maxspec], nil, nil )
            end_line( " #{struct[:max]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :minspec ) && struct.has_key?( :min ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            add " #{params[0]} "
            _gen_relationalop( struct[:minspec], nil, nil )
            end_line( " #{struct[:min]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :maxspec ) && struct.has_key?( :max ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            add " #{params[0]} "
            _gen_relationalop( struct[:maxspec], nil, nil )
            end_line( " #{struct[:max]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :min ) && struct.has_key?( :max ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} >= #{struct[:min]} && #{params[0]} <= #{struct[:max]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :min ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} >= #{struct[:min]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      elsif ( struct.is_a?( Hash ) && struct.has_key?( :max ) )
        if params
          if params.length == 1
            begin_line ""
            _gen_notop( struct, nil, nil )
            end_line( " #{params[0]} <= #{struct[:max]}" )
            indent
            add_line "return false"
            unindent
            add_line "end"
          end
        end
      end
    end

    def _gen_notop( struct, label = nil, params = nil )
      if ( struct.is_a?( Hash ) && struct.has_key?( :notop ) && struct[:notop] == :notop )
        if label
          case label
          when "boolop"
            add "! "
          end
        else
          unless label || params
            add "if"
          end
        end
      elsif true
        if label
          case label
          when "boolop"
            add ""
          end
        else
          unless label || params
            add "unless"
          end
        end
      end
    end

    def _gen_relationalop( struct, label = nil, params = nil )
      if ( struct.is_a?( Symbol ) && struct == :gt )
        unless label || params
          add ">"
        end
      elsif ( struct.is_a?( Symbol ) && struct == :gte )
        unless label || params
          add ">="
        end
      elsif ( struct.is_a?( Symbol ) && struct == :lt )
        unless label || params
          add "<"
        end
      elsif ( struct.is_a?( Symbol ) && struct == :lte )
        unless label || params
          add "<="
        end
      end
    end

  end

end
