# -*- coding: utf-8 -*-
# requires full accessable first_name and last_name attributes
module FullNameSplitter

  # prefixes
  NAME_PREFIXES = ["mr", "ms", "miss", "mrs", "dr", "sir", "phd", "prof", "gen", "rep", "st"]

  # suffixes
  NAME_SUFFIXES = ["jr", "jr.", "sr", "sr.", "phd", "phd.", "md", "md." "ii", "iii", "iv"]

  # last_name prefixes with different culture
  LAST_NAME_PREFIXES = %w(de da la du del dei vda. dello della degli delle van von der den heer ten ter vande vanden vander voor ver aan mc ben).freeze

  INVALID_CHAR_REGEXP = /[^A-Za-z.\-\'\s\,]+/

  class Splitter
    
    def initialize(full_name)
      @full_name  = full_name
      @first_name = []
      @middle_name = []
      @last_name  = []
      @prefix = []
      @suffix = []
      split!
    end

    def split!

      # deals with comma, eg. Smith, John => John Smith
      tokens = @full_name.split(',')
      if tokens.size == 2
        @full_name = (tokens[1] + ' ' + tokens[0]).lstrip
      end

      @units = @full_name.split(/\s+/)
      # if have prefix
      if @units.first && NAME_PREFIXES.include?(@units.first.downcase)
        @prefix << @units.shift()
      end

      # if have suffix
      if @units.last && NAME_SUFFIXES.include?(@units.last.downcase)
        @suffix << @units.pop()
      end

      while @unit = @units.shift do
        if last_name_prefix? or with_apostrophe? or (first_name? and last_unit? and not initial?)
          @last_name << @unit and break
        else
          @first_name << @unit
        end
      end
      @last_name += @units

      #handle exceptions for different cultures
      #adjust_exceptions!

      # if first_name is longer than 2 words, use the first word as first_name and the rest as middle_name
      if @first_name.size >= 2
        first_word = []
        first_word << @first_name.shift()
        @middle_name = @first_name
        @first_name = first_word
      end

    end

    def first_name
      @first_name.empty? ? nil : @first_name.join(' ')
    end

    def middle_name
      @middle_name.empty? ? nil : @middle_name.join(' ')
    end

    def last_name
      @last_name.empty? ? nil : @last_name.join(' ')
    end

    def prefix
      @prefix.empty? ? nil : @prefix.join(' ')
    end

    def suffix
      @suffix.empty? ? nil : @suffix.join(' ')
    end


    private

    def last_name_prefix?
      LAST_NAME_PREFIXES.include?(@unit.downcase)
    end

    # M or W.
    def initial?
      @unit =~ /^\w\.?$/
    end

    # O'Connor, d'Artagnan match
    # Noda' doesn't match
    def with_apostrophe?
      @unit =~ /\w{1}'\w+/
    end
    
    def last_unit?
      @units.empty?
    end
    
    def first_name?
      not @first_name.empty?
    end
    
    def adjust_exceptions!
      return if @first_name.size <= 1
      
      # Adjusting exceptions like 
      # "Ludwig Mies van der Rohe"      => ["Ludwig",         "Mies van der Rohe"   ]
      # "Juan Martín de la Cruz Gómez"  => ["Juan Martín",    "de la Cruz Gómez"    ]
      # "Javier Reyes de la Barrera"    => ["Javier",         "Reyes de la Barrera" ]
      # Rosa María Pérez Martínez Vda. de la Cruz 
      #                                 => ["Rosa María",     "Pérez Martínez Vda. de la Cruz"]
      if last_name =~ /^(van der|(vda\. )?de la \w+$)/i
        loop do
          @last_name.unshift @first_name.pop
          break if @first_name.size <= 2
        end
      end
    end
  end
  
  def full_name
    [first_name, middle_name, last_name].compact.join(' ')
  end
  
  def full_name=(name)
    self.first_name, self.middle_name, self.last_name = split(name)
  end
  
  private 
  
  def split(name)
    name = name.to_s.strip.gsub(/\s+/, ' ')

    splitter = Splitter.new(name)
    [splitter.first_name, splitter.middle_name, splitter.last_name, splitter.prefix, splitter.suffix]

  end
  
  module_function :split
end
