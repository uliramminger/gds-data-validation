# lng_gds_check.rb

module LDLgeneratedLanguage

  class Language_gds_check
    require 'treetop'

    class SyntaxError < ::StandardError
    end

    def self.parse( s )
      @parserClass ||= begin
        Treetop.load_from_string GrammarDef
        instance_eval( 'Language_gds_check_05Parser' )
      end
      parser = @parserClass.new

      parseTree = parser.parse( s + "\n" )

      unless parseTree
        lineOfFailure   = parser.failure_line
        columnOfFailure = parser.failure_column

        s = "LANGUAGE_GDS_CHECK: Error happend, while parsing the definition: line #{lineOfFailure}, column #{columnOfFailure}" + "\n"
        s += parser.failure_reason + "\n"  if parser.failure_reason
        s += "--->" + "\n"
        s += parser.input.lines[((lineOfFailure-1-5)>0 ? (lineOfFailure-1-5) : 0)..(lineOfFailure-1)].join.chomp + "\n"
        s += ' '*((parser.failure_column) -1) + '^' + "\n"
        s += "<---" + "\n"

        raise SyntaxError, s
      end

      parseTree.ast
    end

    GrammarDef = "grammar Language_gds_check_05\n\n  rule top\n    defs ''\n    {\n      def ast\n        defs.ast\n      end\n    }\n  end\n\n  rule defs\n    wscommnl2 productionrule_l:(productionrule*)  wscommnl2\n    {\n      def ast\n        r = []\n        productionrule_l.elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule productionrule\n    rulename wscommnl2 '=' wscommnl2 ruledefinition \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :name, rulename.ast ] )\n        r.merge!( Hash[ :ruledefinition, ruledefinition.ast ] )\n        r\n      end\n    }\n  end\n\n  rule rulename\n    identifier ''\n    {\n      def ast\n        identifier.ast\n      end\n    }\n  end\n\n  rule ruledefinition\n    alternatives ''\n    {\n      def ast\n        alternatives.ast\n      end\n    }\n  end\n\n  rule alternatives\n    alternative_mb wscommnl2 '/' wscommnl2 alternatives \n    {\n      def ast\n        r = []\n        r << alternative_mb.ast\n        r2 = alternatives.ast\n        if r2.is_a?(Array); r.concat( r2 ); else r << r2; end\n        r\n      end\n    }\n    /\n    alternative_mb '' \n    {\n      def ast\n        r = []\n        r << alternative_mb.ast\n        r\n      end\n    }\n  end\n\n  rule alternative_mb\n    mb:maybe? wscommnl2 alternative \n    {\n      def ast\n        r = {}\n        r.merge!( alternative.ast )\n        r.merge!( Hash[ :maybe, mb.ast ] )  unless mb.empty?\n        r\n      end\n    }\n  end\n\n  rule alternative\n    hashdef wscommnl2 \n    {\n      def ast\n        hashdef.ast\n      end\n    }\n    /\n    structuraldef wscommnl2 \n    {\n      def ast\n        structuraldef.ast\n      end\n    }\n  end\n\n  rule hashdef\n    sk:strictkeys? wscommnl2 keyvaluedefs \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :hashdef, keyvaluedefs.ast ] )\n        r.merge!( Hash[ :strict, sk.ast ] )  unless sk.empty?\n        r\n      end\n    }\n  end\n\n  rule arraydef\n    rulename sizespec \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :rulename, rulename.ast ] )\n        r1.merge!( Hash[ :sizespec, sizespec.ast ] )\n        r.merge!( Hash[ :arraydef, r1 ] )\n        r\n      end\n    }\n  end\n\n  rule subruledef\n    rulename '' \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :rulename, rulename.ast ] )\n        r.merge!( Hash[ :subruledef, r1 ] )\n        r\n      end\n    }\n  end\n\n  rule strictkeys\n    '@strict' \n    {\n      def ast\n        :strict\n      end\n    }\n  end\n\n  rule keyvaluedefs\n    keyvaluedef wscommnl2 ',' wscommnl2 keyvaluedefs \n    {\n      def ast\n        r = []\n        r << keyvaluedef.ast\n        r2 = keyvaluedefs.ast\n        if r2.is_a?(Array); r.concat( r2 ); else r << r2; end\n        r\n      end\n    }\n    /\n    keyvaluedef '' \n    {\n      def ast\n        r = []\n        r << keyvaluedef.ast\n        r\n      end\n    }\n  end\n\n  rule keyvaluedef\n    keydef wscommnl2 ':?' wscommnl2 structuraldef_mb \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :key, keydef.ast ] )\n        r1.merge!( Hash[ :value, structuraldef_mb.ast ] )\n        r1.merge!( Hash[ :optional, :optional ] )\n        r.merge!( Hash[ :keyvaluedef, r1 ] )\n        r\n      end\n    }\n    /\n    keydef wscommnl2 ':' wscommnl2 structuraldef_mb \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :key, keydef.ast ] )\n        r1.merge!( Hash[ :value, structuraldef_mb.ast ] )\n        r.merge!( Hash[ :keyvaluedef, r1 ] )\n        r\n      end\n    }\n  end\n\n  rule keydef\n    wscommnl2 ':' identifier \n    {\n      def ast\n        identifier.ast\n      end\n    }\n  end\n\n  rule structuraldef_mb\n    mb:maybe? wscommnl2 structuraldef \n    {\n      def ast\n        r = {}\n        r.merge!( structuraldef.ast )\n        r.merge!( Hash[ :maybe, mb.ast ] )  unless mb.empty?\n        r\n      end\n    }\n  end\n\n  rule structuraldef\n    no:notop? wscommnl2 '(' wscommnl2 typevaldef_disjunction wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valdefdisjunct, typevaldef_disjunction.ast ] )\n        r.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r\n      end\n    }\n    /\n    typevaldef_disjunction '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valdefdisjunct, typevaldef_disjunction.ast ] )\n        r\n      end\n    }\n    /\n    no:notop? wscommnl2 typedef \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( typedef.ast )\n        r1.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( Hash[ :typedef, r1 ] )\n        r\n      end\n    }\n    /\n    basicvaldef '' \n    {\n      def ast\n        basicvaldef.ast\n      end\n    }\n    /\n    arraydef '' \n    {\n      def ast\n        r = {}\n        r.merge!( arraydef.ast )\n        r\n      end\n    }\n    /\n    subruledef '' \n    {\n      def ast\n        r = {}\n        r.merge!( subruledef.ast )\n        r\n      end\n    }\n  end\n\n  rule basicvaldef\n    rubysymbol '' \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :type, :t_symbol ] )\n        r1.merge!( Hash[ :value, rubysymbol.ast ] )\n        r.merge!( Hash[ :basicvaluedef, r1 ] )\n        r\n      end\n    }\n    /\n    string '' \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :type, :t_string ] )\n        r1.merge!( Hash[ :value, string.ast ] )\n        r.merge!( Hash[ :basicvaluedef, r1 ] )\n        r\n      end\n    }\n    /\n    number_float '' \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :type, :t_float ] )\n        r1.merge!( Hash[ :value, number_float.ast ] )\n        r.merge!( Hash[ :basicvaluedef, r1 ] )\n        r\n      end\n    }\n    /\n    number_int '' \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( Hash[ :type, :t_int ] )\n        r1.merge!( Hash[ :value, number_int.ast ] )\n        r.merge!( Hash[ :basicvaluedef, r1 ] )\n        r\n      end\n    }\n    /\n    keyword_literal '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :basicvaluedef, keyword_literal.ast ] )\n        r\n      end\n    }\n  end\n\n  rule typevaldef_disjunction\n    tvclause wscommnl2 '|' wscommnl2 tvclauses \n    {\n      def ast\n        r = []\n        r << tvclause.ast\n        r2 = tvclauses.ast\n        if r2.is_a?(Array); r.concat( r2 ); else r << r2; end\n        r\n      end\n    }\n  end\n\n  rule tvclauses\n    tvclause wscommnl2 '|' wscommnl2 tvclauses \n    {\n      def ast\n        r = []\n        r << tvclause.ast\n        r2 = tvclauses.ast\n        if r2.is_a?(Array); r.concat( r2 ); else r << r2; end\n        r\n      end\n    }\n    /\n    tvclause '' \n    {\n      def ast\n        r = []\n        r << tvclause.ast\n        r\n      end\n    }\n  end\n\n  rule tvclause\n    no:notop? wscommnl2 typedef \n    {\n      def ast\n        r = {}\n        r1 = {}\n        r1.merge!( typedef.ast )\n        r1.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( Hash[ :typedef, r1 ] )\n        r\n      end\n    }\n    /\n    basicvaldef '' \n    {\n      def ast\n        basicvaldef.ast\n      end\n    }\n  end\n\n  rule sizespec\n    '+'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    '*'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    '(' wscommnl2 '..' wscommnl2 number_int wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :max, number_int.ast ] )\n        r\n      end\n    }\n    /\n    '(' wscommnl2 a:number_int wscommnl2 '..' wscommnl2 b:number_int wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, a.ast ] )\n        r.merge!( Hash[ :max, b.ast ] )\n        r\n      end\n    }\n    /\n    '(' wscommnl2 number_int wscommnl2 '..' wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, number_int.ast ] )\n        r\n      end\n    }\n    /\n    '(' wscommnl2 number_int wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, number_int.ast ] )\n        r.merge!( Hash[ :max, number_int.ast ] )\n        r\n      end\n    }\n  end\n\n  rule typedef\n    typedef_string ''\n    {\n      def ast\n        typedef_string.ast\n      end\n    }\n    /\n    typedef_int ''\n    {\n      def ast\n        typedef_int.ast\n      end\n    }\n    /\n    typedef_float ''\n    {\n      def ast\n        typedef_float.ast\n      end\n    }\n    /\n    '@t_numeric' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_numeric ] )\n        r\n      end\n    }\n    /\n    '@t_nil' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_nil ] )\n        r\n      end\n    }\n    /\n    '@t_bool' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_bool ] )\n        r\n      end\n    }\n    /\n    '@t_true' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_true ] )\n        r\n      end\n    }\n    /\n    '@t_false' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_false ] )\n        r\n      end\n    }\n    /\n    typedef_symbol ''\n    {\n      def ast\n        typedef_symbol.ast\n      end\n    }\n    /\n    '@t_any' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_any ] )\n        r\n      end\n    }\n  end\n\n  rule typedef_int\n    wscommnl2 '@t_int' wscommnl2 ivs:intvaluespecs? \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_int ] )\n        r.merge!( Hash[ :valuespecs, ivs.ast ] )  unless ivs.empty?\n        r\n      end\n    }\n  end\n\n  rule maybe\n    '@maybe' \n    {\n      def ast\n        :maybe\n      end\n    }\n  end\n\n  rule intvaluespecs\n    intvaluespec_with_not* \n    {\n      def ast\n        r = []\n        elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule intvaluespec_with_not\n    no:notop? wscommnl2 intvaluespec wscommnl2 \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( intvaluespec.ast )\n        r\n      end\n    }\n  end\n\n  rule intvaluespec\n    wscommnl2 '!=' wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :neql ] )\n        r.merge!( Hash[ :val, number_int.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '==' wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :eql ] )\n        r.merge!( Hash[ :val, number_int.ast ] )\n        r\n      end\n    }\n    /\n    intvaluespec_keywords '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, intvaluespec_keywords.ast ] )\n        r\n      end\n    }\n    /\n    intminmaxspec ''\n    {\n      def ast\n        intminmaxspec.ast\n      end\n    }\n    /\n    intvaluelist '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valuelist, intvaluelist.ast ] )\n        r\n      end\n    }\n  end\n\n  rule intvaluespec_keywords\n    'odd'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    'even'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule intvaluelist\n    wscommnl2 '[' wscommnl2 intvalues_comma wscommnl2 ']'\n    {\n      def ast\n        intvalues_comma.ast\n      end\n    }\n    /\n    wscommnl2 '%(' wscommnl2 intvalues_nocomma wscommnl2 ')'\n    {\n      def ast\n        intvalues_nocomma.ast\n      end\n    }\n  end\n\n  rule intvalues_comma\n    number_int wscommnl2 onemorenumint_comma_l:(onemorenumint_comma*) \n    {\n      def ast\n        r = []\n        r << number_int.ast\n        r1 = []\n        onemorenumint_comma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorenumint_comma\n    wscommnl2 ',' wscommnl2 number_int\n    {\n      def ast\n        number_int.ast\n      end\n    }\n  end\n\n  rule intvalues_nocomma\n    number_int wscommnl2 onemorenumint_nocomma_l:(onemorenumint_nocomma*) \n    {\n      def ast\n        r = []\n        r << number_int.ast\n        r1 = []\n        onemorenumint_nocomma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorenumint_nocomma\n    ws number_int\n    {\n      def ast\n        number_int.ast\n      end\n    }\n  end\n\n  rule typedef_string\n    wscommnl2 '@t_string' wscommnl2 svs:stringvaluespecs? \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_string ] )\n        r.merge!( Hash[ :valuespecs, svs.ast ] )  unless svs.empty?\n        r\n      end\n    }\n  end\n\n  rule stringvaluespecs\n    stringvaluespec_with_not* \n    {\n      def ast\n        r = []\n        elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule stringvaluespec_with_not\n    no:notop? wscommnl2 stringvaluespec wscommnl2 \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( stringvaluespec.ast )\n        r\n      end\n    }\n  end\n\n  rule stringvaluespec\n    wscommnl2 '!=' wscommnl2 string \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :neql ] )\n        r.merge!( Hash[ :val, string.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '==' wscommnl2 string \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :eql ] )\n        r.merge!( Hash[ :val, string.ast ] )\n        r\n      end\n    }\n    /\n    stringvaluespec_keywords '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, stringvaluespec_keywords.ast ] )\n        r\n      end\n    }\n    /\n    lengthspec ''\n    {\n      def ast\n        lengthspec.ast\n      end\n    }\n    /\n    stringvaluelist '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valuelist, stringvaluelist.ast ] )\n        r\n      end\n    }\n    /\n    regexp '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :regexp ] )\n        r.merge!( regexp.ast )\n        r\n      end\n    }\n  end\n\n  rule stringvaluespec_keywords\n    'blank'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    'empty'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    'present'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n    /\n    'something'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule stringvaluelist\n    wscommnl2 '[' wscommnl2 stringvalues_comma wscommnl2 ']'\n    {\n      def ast\n        stringvalues_comma.ast\n      end\n    }\n    /\n    wscommnl2 '%(' wscommnl2 stringvalues_nocomma wscommnl2 ')'\n    {\n      def ast\n        stringvalues_nocomma.ast\n      end\n    }\n  end\n\n  rule stringvalues_comma\n    string wscommnl2 onemorestring_comma_l:(onemorestring_comma*) \n    {\n      def ast\n        r = []\n        r << string.ast\n        r1 = []\n        onemorestring_comma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorestring_comma\n    wscommnl2 ',' wscommnl2 string\n    {\n      def ast\n        string.ast\n      end\n    }\n  end\n\n  rule stringvalues_nocomma\n    stringnoblank wscommnl2 onemorestring_nocomma_l:(onemorestring_nocomma*) \n    {\n      def ast\n        r = []\n        r << stringnoblank.ast\n        r1 = []\n        onemorestring_nocomma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorestring_nocomma\n    ws stringnoblank\n    {\n      def ast\n        stringnoblank.ast\n      end\n    }\n  end\n\n  rule typedef_float\n    wscommnl2 '@t_float' wscommnl2 vs:floatvaluespecs? \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_float ] )\n        r.merge!( Hash[ :valuespecs, vs.ast ] )  unless vs.empty?\n        r\n      end\n    }\n  end\n\n  rule floatvaluespecs\n    floatvaluespec_with_not* \n    {\n      def ast\n        r = []\n        elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule floatvaluespec_with_not\n    no:notop? wscommnl2 floatvaluespec wscommnl2 \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( floatvaluespec.ast )\n        r\n      end\n    }\n  end\n\n  rule floatvaluespec\n    wscommnl2 '!=' wscommnl2 number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :neql ] )\n        r.merge!( Hash[ :val, number_float.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '==' wscommnl2 number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :eql ] )\n        r.merge!( Hash[ :val, number_float.ast ] )\n        r\n      end\n    }\n    /\n    floatminmaxspec ''\n    {\n      def ast\n        floatminmaxspec.ast\n      end\n    }\n    /\n    floatvaluelist '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valuelist, floatvaluelist.ast ] )\n        r\n      end\n    }\n  end\n\n  rule floatminmaxspec\n    min wscommnl2 a:number_float wscommnl2 max wscommnl2 b:number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, a.ast ] )\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, b.ast ] )\n        r\n      end\n    }\n    /\n    max wscommnl2 a:number_float wscommnl2 min wscommnl2 b:number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, a.ast ] )\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, b.ast ] )\n        r\n      end\n    }\n    /\n    min wscommnl2 number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, number_float.ast ] )\n        r\n      end\n    }\n    /\n    max wscommnl2 number_float \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, number_float.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 a:number_float wscommnl2 '..' wscommnl2 b:number_float wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, a.ast ] )\n        r.merge!( Hash[ :max, b.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 number_float wscommnl2 '..' wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, number_float.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 '..' wscommnl2 number_float wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :max, number_float.ast ] )\n        r\n      end\n    }\n  end\n\n  rule floatvaluelist\n    wscommnl2 '[' wscommnl2 floatvalues_comma wscommnl2 ']'\n    {\n      def ast\n        floatvalues_comma.ast\n      end\n    }\n    /\n    wscommnl2 '%(' wscommnl2 floatvalues_nocomma wscommnl2 ')'\n    {\n      def ast\n        floatvalues_nocomma.ast\n      end\n    }\n  end\n\n  rule floatvalues_comma\n    number_float wscommnl2 onemorenumfloat_comma_l:(onemorenumfloat_comma*) \n    {\n      def ast\n        r = []\n        r << number_float.ast\n        r1 = []\n        onemorenumfloat_comma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorenumfloat_comma\n    wscommnl2 ',' wscommnl2 number_float\n    {\n      def ast\n        number_float.ast\n      end\n    }\n  end\n\n  rule floatvalues_nocomma\n    number_float wscommnl2 onemorenumfloat_nocomma_l:(onemorenumfloat_nocomma*) \n    {\n      def ast\n        r = []\n        r << number_float.ast\n        r1 = []\n        onemorenumfloat_nocomma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemorenumfloat_nocomma\n    ws number_float\n    {\n      def ast\n        number_float.ast\n      end\n    }\n  end\n\n  rule typedef_symbol\n    wscommnl2 '@t_symbol' wscommnl2 vs:symbolvaluespecs? \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_symbol ] )\n        r.merge!( Hash[ :valuespecs, vs.ast ] )  unless vs.empty?\n        r\n      end\n    }\n  end\n\n  rule symbolvaluespecs\n    symbolvaluespec_with_not* \n    {\n      def ast\n        r = []\n        elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule symbolvaluespec_with_not\n    no:notop? wscommnl2 symbolvaluespec wscommnl2 \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :notop, no.ast ] )  unless no.empty?\n        r.merge!( symbolvaluespec.ast )\n        r\n      end\n    }\n  end\n\n  rule symbolvaluespec\n    wscommnl2 '!=' wscommnl2 rubysymbol \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :neql ] )\n        r.merge!( Hash[ :val, rubysymbol.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '==' wscommnl2 rubysymbol \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :eql ] )\n        r.merge!( Hash[ :val, rubysymbol.ast ] )\n        r\n      end\n    }\n    /\n    lengthspec ''\n    {\n      def ast\n        lengthspec.ast\n      end\n    }\n    /\n    symbolvaluelist '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :valuelist, symbolvaluelist.ast ] )\n        r\n      end\n    }\n    /\n    regexp '' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :regexp ] )\n        r.merge!( regexp.ast )\n        r\n      end\n    }\n  end\n\n  rule symbolvaluelist\n    wscommnl2 '[' wscommnl2 symbolvalues_comma wscommnl2 ']'\n    {\n      def ast\n        symbolvalues_comma.ast\n      end\n    }\n    /\n    wscommnl2 '%(' wscommnl2 symbolvalues_nocomma wscommnl2 ')'\n    {\n      def ast\n        symbolvalues_nocomma.ast\n      end\n    }\n  end\n\n  rule symbolvalues_comma\n    rubysymbol wscommnl2 onemoresymbol_comma_l:(onemoresymbol_comma*) \n    {\n      def ast\n        r = []\n        r << rubysymbol.ast\n        r1 = []\n        onemoresymbol_comma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemoresymbol_comma\n    wscommnl2 ',' wscommnl2 rubysymbol\n    {\n      def ast\n        rubysymbol.ast\n      end\n    }\n  end\n\n  rule symbolvalues_nocomma\n    rubysymbolcontent wscommnl2 onemoresymbol_nocomma_l:(onemoresymbol_nocomma*) \n    {\n      def ast\n        r = []\n        r << rubysymbolcontent.ast\n        r1 = []\n        onemoresymbol_nocomma_l.elements.each do |e|\n          r1 << e.ast\n        end\n        r.concat( r1 )\n        r\n      end\n    }\n  end\n\n  rule onemoresymbol_nocomma\n    ws rubysymbolcontent\n    {\n      def ast\n        rubysymbolcontent.ast\n      end\n    }\n  end\n\n  rule notop\n    !'!=' '!'  \n    {\n      def ast\n        :notop\n      end\n    }\n  end\n\n  rule intminmaxspec\n    min wscommnl2 a:number_int wscommnl2 max wscommnl2 b:number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, a.ast ] )\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, b.ast ] )\n        r\n      end\n    }\n    /\n    max wscommnl2 a:number_int wscommnl2 min wscommnl2 b:number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, a.ast ] )\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, b.ast ] )\n        r\n      end\n    }\n    /\n    min wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :minspec, min.ast ] )\n        r.merge!( Hash[ :min, number_int.ast ] )\n        r\n      end\n    }\n    /\n    max wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :maxspec, max.ast ] )\n        r.merge!( Hash[ :max, number_int.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 a:number_int wscommnl2 '..' wscommnl2 b:number_int wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, a.ast ] )\n        r.merge!( Hash[ :max, b.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 number_int wscommnl2 '..' wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :min, number_int.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 '(' wscommnl2 '..' wscommnl2 number_int wscommnl2 ')' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :max, number_int.ast ] )\n        r\n      end\n    }\n  end\n\n  rule min\n    '>=' \n    {\n      def ast\n        :gte\n      end\n    }\n    /\n    '>' \n    {\n      def ast\n        :gt\n      end\n    }\n  end\n\n  rule max\n    '<=' \n    {\n      def ast\n        :lte\n      end\n    }\n    /\n    '<' \n    {\n      def ast\n        :lt\n      end\n    }\n  end\n\n  rule lengthspec\n    wscommnl2 'length' wscommnl2 '==' wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :length ] )\n        r.merge!( Hash[ :relop, :eql ] )\n        r.merge!( Hash[ :val, number_int.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 'length' wscommnl2 '!=' wscommnl2 number_int \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :length ] )\n        r.merge!( Hash[ :relop, :neql ] )\n        r.merge!( Hash[ :val, number_int.ast ] )\n        r\n      end\n    }\n    /\n    wscommnl2 'length' wscommnl2 intminmaxspec \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :spec, :length ] )\n        r.merge!( intminmaxspec.ast )\n        r\n      end\n    }\n  end\n\n  rule keyword_literal\n    'true' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_true ] )\n        r.merge!( Hash[ :value, :true ] )\n        r\n      end\n    }\n    /\n    'false' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_false ] )\n        r.merge!( Hash[ :value, :false ] )\n        r\n      end\n    }\n    /\n    'nil' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_nil ] )\n        r.merge!( Hash[ :value, :nil ] )\n        r\n      end\n    }\n    /\n    'null' \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :type, :t_nil ] )\n        r.merge!( Hash[ :value, :nil ] )\n        r\n      end\n    }\n  end\n\n  rule rubysymbol\n    wscommnl2 ':' rubysymbolcontent \n    {\n      def ast\n        rubysymbolcontent.ast\n      end\n    }\n  end\n\n  rule rubysymbolcontent\n    wscommnl2 '\"' rubysymbol_in_double_quotes '\"' \n    {\n      def ast\n        rubysymbol_in_double_quotes.ast\n      end\n    }\n    /\n    wscommnl2 '\\'' rubysymbol_in_single_quotes '\\'' \n    {\n      def ast\n        rubysymbol_in_single_quotes.ast\n      end\n    }\n    /\n    ( !'(' !')' !'}' !' ' !',' !']' !'#' !'/*' !'*/' !\"\\n\" .)+ \n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule rubysymbol_in_double_quotes\n    ('\\\"' / !'\"' !\"\\n\" .)+ \n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule rubysymbol_in_single_quotes\n    ('\\\\\\'' / !'\\'' !\"\\n\" .)+ \n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule string\n    string_with_doublequotes ''\n    {\n      def ast\n        string_with_doublequotes.ast\n      end\n    }\n  end\n\n  rule string_with_doublequotes\n    wscommnl2 '\"' string_double_q '\"'\n    {\n      def ast\n        string_double_q.ast\n      end\n    }\n  end\n\n  rule string_double_q\n    ('\\\\\\\\' / '\\\"' / !'\"' .)* \n    {\n      def ast\n        \n        text_value.gsub(/(\\\\\\\\)|(\\\\n)|(\\\\\")/, '\\\\\\\\'=>'\\\\', \"\\\\n\"=>\"\\n\", '\\\\\"'=>'\"')\n      \n      end\n    }\n  end\n\n  rule stringnoblank\n    (!' ' !'(' !')' .)+ \n    {\n      def ast\n         text_value \n      end\n    }\n  end\n\n  rule regexp\n    wscommnl2 '/' wscommnl2 regexp_inner wscommnl2 '/' regexp_options \n    {\n      def ast\n        r = {}\n        r.merge!( Hash[ :regexp, regexp_inner.ast ] )\n        r.merge!( Hash[ :options, regexp_options.ast ] )\n        r\n      end\n    }\n  end\n\n  rule regexp_options\n    regexp_option* \n    {\n      def ast\n        r = []\n        elements.each do |e|\n          r << e.ast\n        end\n        r\n      end\n    }\n  end\n\n  rule regexp_option\n    'i'\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule regexp_inner\n    ('\\\\\\\\' / '\\/' / !'/' .)* \n    {\n      def ast\n        \n    #text_value.gsub(/(\\\\\\\\)|(\\\\n)|(\\\\\")/, '\\\\\\\\'=>'\\\\', \"\\\\n\"=>\"\\n\", '\\\\\"'=>'\"')\n    text_value # .gsub(/(\\\\\\\\)|(\\\\n)|(\\\\\")/, '\\\\\\\\'=>'\\\\', \"\\\\n\"=>\"\\n\", '\\\\\"'=>'\"')\n  \n      end\n    }\n  end\n\n  rule number_int\n    ('-'/'+')? ([1-9]) ([0-9])*  \n    {\n      def ast\n        text_value.to_i\n      end\n    }\n    /\n    [0]  \n    {\n      def ast\n        text_value.to_i\n      end\n    }\n  end\n\n  rule number_float\n    [+-]? ( [0-9] / '_' [0-9] )* [.] [0-9] ( [0-9] / '_' [0-9] )* (('e'/'E') [+-]? [0-9] ( [0-9] / '_' [0-9] )* )?  \n    {\n      def ast\n        text_value.to_f\n      end\n    }\n  end\n\n  rule wsc\n    [ \\t] \n    {\n    }\n  end\n\n  rule identifier\n    ([a-zA-Z_] [a-zA-Z0-9_]*)\n    {\n      def ast\n        text_value.to_sym\n      end\n    }\n  end\n\n  rule string_no_space\n    [a-zA-Z0-9_/.:]+\n    {\n      def ast\n        text_value\n      end\n    }\n  end\n\n  rule indentation\n    ' '*\n  end\n\n  rule ws\n    wsc*\n  end\n\n  rule icomm\n    '#'\n  end\n\n  rule wscommnl\n    ws ( icomm ( !\"\\n\" . )* )? \"\\n\"\n  end\n\n  rule wscommnl2\n    ( icomm ( !\"\\n\" . )* \"\\n\" / \"\\n\" / wsc )*\n  end\n\nend\n"

  end
end
