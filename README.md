gds-data-validation
===================

A data validation library providing a rule-based schema definition language.    
For checking (incoming) data against a specified schema definition.    
GDS stands for General Data Structure.    

Installation
============

~~~
gem install gds-data-validation
~~~

An Example
==========

~~~ruby
require "gds-data-validation"

dataValidation = GdsDataValidation.create( <<-EOS )
company = :name        : @t_string,
          :address     : address,
          :ceo         : person,
          :employees   : person*
person =  :firstname   : @t_string,
          :lastname    : @t_string,
          :yearOfBirth : @t_int,
          :address     : address
address = :street      : @t_string,
          :zipcode     : @t_int,
          :city        : @t_string
EOS

dataValidation.check( nil )   # => false
dataValidation.check(
  { name: 'My Company', address: { street: 'Broadway 300', zipcode: 22222, city: 'New York' },
    ceo: { firstname: 'John', lastname: 'McArthur', yearOfBirth: 1959,
           address: { street: 'Rosedale Dr. 40', zipcode: 34003, city: 'Los Angeles' } },
    employees: [
      { firstname: 'Berry', lastname: 'Miller', yearOfBirth: 1989,
        address: { street: 'South St. 12', zipcode: 48333, city: 'Chicago' } },
      { firstname: 'Jane', lastname: 'Smith', yearOfBirth: 1993,
        address: { street: 'Mainstreet 4', zipcode: 62883, city: 'Seattle' } } ] }
)   # => true
~~~

Introduction
============

The original idea was to create a library for the validation of data structures which have been created
by the [GDS (General Data Structure)](https://urasepandia.de/gds.html) language.

Synonyms and related terms are data validation, validation checker, schema validation, schema validator, schema checker.

Ruby Gem
========

You can find it on RubyGems.org:  

[rubygems.org/gems/gds-data-validation](https://rubygems.org/gems/gds-data-validation)

Source Code
===========

You can find the source code on GitHub:  

[github.com/uliramminger/gds-data-validation](https://github.com/uliramminger/gds-data-validation)

Further Information
===================

You will find detailed information here:  [urasepandia.de/gds-data-validation.html](https://urasepandia.de/gds-data-validation.html)

Maintainer
==========

Uli Ramminger <uli@urasepandia.de>

Copyright
=========

Copyright (c) 2019 Ulrich Ramminger

See MIT-LICENSE for further details.
