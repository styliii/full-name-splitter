# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Incognito
  include FullNameSplitter
  attr_accessor :first_name, :middle_name, :last_name
end

describe Incognito do
  describe "#full_name=" do

    #
    # Environment
    #

    subject { Incognito.new }

    def gum(first, middle, last)
      "[#{first}] + [#{middle}] + [#{last}]"
    end



    #
    # Examples
    #

    {
      "John Smith"                    => ["John",     nil,        "Smith"             ,nil   ],
      "Kevin J. O'Connor"             => ["Kevin",    "J.",      "O'Connor"           ,nil   ],
      "Gabriel Van Helsing"           => ["Gabriel",  nil,      "Van Helsing"         ,nil   ],
      "Pierre de Montesquiou"         => ["Pierre",   nil,      "de Montesquiou"      ,nil   ],
      "Charles d'Artagnan"            => ["Charles",  nil,      "d'Artagnan"          ,nil   ],
      "Jaazaniah ben Shaphan"         => ["Jaazaniah", nil,     "ben Shaphan"         ,nil   ],
      "Noda' bi-Yehudah"              => ["Noda'",    nil,      "bi-Yehudah"          ,nil   ],
      "Maria del Carmen Menendez"     => ["Maria",    nil,      "del Carmen Menendez" ,nil   ],
      "Alessandro Del Piero"          => ["Alessandro",  nil,   "Del Piero"           ,nil   ],

      "George W Bush"                 => ["George",  "W",     "Bush"               ,nil   ],
      "George H. W. Bush"             => ["George",  "H. W.", "Bush"                ,nil   ],
      "James K. Polk"                 => ["James", "K.",   "Polk"                   ,nil   ],
      "William Henry Harrison"        => ["William", "Henry", "Harrison"            ,nil   ],
      "John Quincy Adams"             => ["John", "Quincy",  "Adams"               ,nil   ],

      "John Quincy"                   => ["John",     nil,      "Quincy"              ,nil   ],
      "George H. W."                  => ["George",   "H. W.",   nil                   ,nil   ],
      "Van Helsing"                   => [nil,       nil,       "Van Helsing"         ,nil   ],
      "d'Artagnan"                    => [nil,       nil,       "d'Artagnan"          ,nil   ],
      "O'Connor"                      => [nil,       nil,       "O'Connor"            ,nil   ],

      "George"                        => ["George",    nil,     nil                   ,nil   ],
      "Kevin J. "                     => ["Kevin",    "J.",   nil                   ,nil   ],

      "Thomas G. Della Fave"          => ["Thomas",   "G.",   "Della Fave"          ,nil   ],
      "Anne du Bourg"                 => ["Anne",     nil,      "du Bourg"            ,nil   ],

      # German
      "Johann Wolfgang von Goethe"    => ["Johann",  "Wolfgang", "von Goethe"         ,nil   ],

      # Spanish-speaking countries
      "Juan Martín de la Cruz Gómez"  => ["Juan", "Martín",    "de la Cruz Gómez"    ,nil   ],
      "Javier Reyes de la Barrera"    => ["Javier", "Reyes",        "de la Barrera" ,nil   ],
      "Rosa María Pérez Martínez Vda. de la Cruz" =>
                                         ["Rosa", "María Pérez Martínez",   "Vda. de la Cruz" ,nil],

      # Italian
      "Federica Pellegrini"           => ["Federica",  nil,     "Pellegrini"          ,nil   ],
      "Leonardo da Vinci"             => ["Leonardo",  nil,     "da Vinci"            ,nil   ],

      # sounds like a fancy medival action movie star pseudonim
      "Alberto Del Sole"              => ["Alberto",   nil,     "Del Sole"            ,nil   ],
      # horror movie star pseudonim?
      "Adriano Dello Spavento"        => ["Adriano",   nil,     "Dello Spavento"      ,nil   ],
      "Luca Delle Fave"               => ["Luca",      nil,     "Delle Fave"          ,nil   ],
      "Francesca Della Valle"         => ["Francesca", nil,     "Della Valle"         ,nil   ],
      "Guido Delle Colonne"           => ["Guido",     nil,     "Delle Colonne"       ,nil   ],
      "Tomasso D'Arco"                => ["Tomasso",   nil,     "D'Arco"              ,nil   ],

      # Dutch
      "Johan de heer Van Kampen"      => ["Johan",    nil,      "de heer Van Kampen"  ,nil   ],
      "Han Van De Casteele"           => ["Han",      nil,      "Van De Casteele"     ,nil   ],
      "Han Vande Casteele"            => ["Han",      nil,      "Vande Casteele"      ,nil   ],

      # Exceptions?
      # the architect Ludwig Mies van der Rohe, from the West German city of Aachen, was originally Ludwig Mies;
      "Ludwig Mies van der Rohe"      => ["Ludwig",    "Mies",     "van der Rohe"   ,nil   ],

      # If comma is provided then split by comma

      #"John, Quincy Adams"             => ["John",  nil,  "Quincy Adams"              ,nil   ],
      #"Ludwig Mies, van der Rohe"      => ["Ludwig Mies", "van der Rohe"          ,nil   ],

      # Test ignoring unnecessary whitespaces
      "\t Ludwig  Mies\t van der Rohe "   => ["Ludwig", "Mies", "van der Rohe"       ,nil   ],
      #"\t Ludwig  Mies,\t van  der Rohe " => ["Ludwig Mies", nil, "van der Rohe"       ,nil   ],
      "\t Ludwig      "                   => ["Ludwig", nil, nil                       ,nil   ],
      "  van  helsing "                   => [nil, nil, "van helsing"                  ,nil   ],
      #" , van  helsing "                  => [nil, nil, "van helsing"                  ,nil   ],
      #"\t Ludwig  Mies,\t van  der Rohe " => ["Ludwig", "Mies", "van der Rohe"       ,nil   ],

      # Test for suffixes
      "John Smith phd."                    => ["John",     nil,        "Smith"   ,"phd."  ],
      "Johann Wolfgang von Goethe Jr."    => ["Johann",  "Wolfgang", "von Goethe",  "Jr." ],


    }.

    each do |full_name, split_name|
      #it "should split #{full_name} to '#{split_name.first}','#{split_name[1]}' and '#{split_name.last}'" do
      #  subject.full_name = full_name
      #  gum(subject.first_name, subject.middle_name, subject.last_name).should == gum(*split_name)
      #end

      it "should split #{full_name} to '#{split_name.first}' , '#{split_name[1]}' and '#{split_name.last}' when called as module function" do
        FullNameSplitter.split(full_name).should == split_name
      end

    end
  end
end
