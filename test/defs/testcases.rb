# testcases.rb

require 'gdstruct'

TestCases = [

[
<<EOS,
main = @maybe @strict :number :? @t_int
EOS
{
  true:
  [
    nil,
    GDstruct.c( <<-EOS ),
    EOS
    GDstruct.c( <<-EOS ),
    number 4
    EOS
  ],
  false:
  [
    GDstruct.c( <<-EOS ),
    number !nil
    EOS
    GDstruct.c( <<-EOS ),
    number 4.0
    EOS
    GDstruct.c( <<-EOS ),
    n2 4.0
    EOS
    GDstruct.c( <<-EOS ),
    number 4 | n2 !nil
    EOS
  ]
}
],

[
<<EOS,
matrix3x3 = row(3)
row = value(3)
value = @t_numeric
EOS
{
  true:
  [
    GDstruct.c( <<-EOS ),
    ,
      ,
        1 | 2 | 3
      ,
        4 | 5 | 6
      ,
        7 | 8 | 9
    EOS
  ],
  false:
  [
    nil,
    GDstruct.c( <<-EOS ),
    ,
      ,
        1 | 2 | 3
      ,
        4 | 5 | 6
    EOS
  ]
}
],



[
<<EOS,
schema = :maindef : :maindef, :name : @t_string, :persons : person*
person = :firstname : @t_string, :lastname : @t_string, :addresses : address*
address = :zipcode : @t_int, :city : @t_string
EOS
{
  true:
  [
    GDstruct.c( <<-EOS ),
    maindef :maindef
    name a
    persons ,
      : firstname b | lastname c
        addresses ,
          : zipcode 1 | city d
    EOS
  ],
  false:
  [
    nil,
    GDstruct.c( <<-EOS ),
    maindef :maindef
    name a
    persons ,
      : firstname b | lastname c
        addresses ,
          : zipcode 1 | city 2
    EOS
  ]
}
],

[
<<EOS,
company = :name : @t_string, :address : address, :ceo : person, :employees : person*
person = :firstname : @t_string, :lastname : @t_string, :yearOfBirth : @t_int, :address : address
address = :street : @t_string, :zipcode : @t_int, :city : @t_string
EOS
{
  true:
  [
    GDstruct.c( <<-EOS ),
    @schema person( firstname, lastname, yearOfBirth )
    name My Company
    address
      street Broadway 300 | zipcode 22222 | city New York
    ceo
      firstname John | lastname McArthur | yearOfBirth 1959
      address
        street Rosedale Dr. 40 | zipcode 34003 | city Los Angeles
    employees , @schema person
      : Berry | Miller | 1989
        address
          street South St. 12 | zipcode 48333 | city Chicago
      : Jane | Smith | 1993
        address
          street Mainstreet 4 | zipcode 62883 | city Seattle
    EOS
  ],
  false:
  [
    nil,
    GDstruct.c( <<-EOS ),
    @schema person( firstname, lastname, yearOfBirth )
    name My Company
    address
      street Broadway 300 | zipcode 22222 | city New York
    ceo
      firstname John | lastname McArthur | yearOfBirth 1959
      address
        street Rosedale Dr. 40 | zipcode 34003 | city Los Angeles
    employees , @schema person
      : Berry | Miller | 1989
        address
          street South St. 12 | zipcode 48333 | city Chicago
      : Jane | Smith | 1993
        address
          street Mainstreet 4 | zipcode 62883 | city 12
    EOS
  ]
}
],

]
