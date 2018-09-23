#Implement all parts of this assignment within (this) module2_assignment2.rb file

#Implement a class called LineAnalyzer.
class LineAnalyzer
  #Implement the following read-only attributes in the LineAnalyzer class. 
  #* highest_wf_count - a number with maximum number of occurrences for a single word (calculated)
  #* highest_wf_words - an array of words with the maximum number of occurrences (calculated)
  #* content,         - the string analyzed (provided)
  #* line_number      - the line number analyzed (provided)
  attr_accessor :highest_wf_count, :highest_wf_words, :content, :line_number

  #Add the following methods in the LineAnalyzer class.
  #* initialize() - taking a line of text (content) and a line number
  #* calculate_word_frequency() - calculates result
  def initialize (content, line_number) #CONSTRUCTOR
    self.highest_wf_words = Array.new
    self.content = content
    self.line_number = line_number
    calculate_word_frequency
  end

  #Implement the initialize() method to:
  #* take in a line of text and line number
  #* initialize the content and line_number attributes
  #* call the calculate_word_frequency() method.

  #Implement the calculate_word_frequency() method to:
  #* calculate the maximum number of times a single word appears within
  #  provided content and store that in the highest_wf_count attribute.
  #* identify the words that were used the maximum number of times and
  #  store that in the highest_wf_words attribute.
  def calculate_word_frequency
    word_frequency = Hash.new(0)
    self.content.split.each do |word|
      word_frequency[word.downcase] += 1
    end
    self.highest_wf_count = word_frequency.values.max
    self.highest_wf_words = word_frequency.select { |k, v| v == highest_wf_count }.keys
  end
end

#  Implement a class called Solution. 
class Solution
  include Enumerable
  # Implement the following read-only attributes in the Solution class.
  #* highest_count_across_lines - a number with the value of the highest frequency of a word
  #* highest_count_words_across_lines - an array with the words with the highest frequency
  attr_accessor :highest_count_across_lines, :highest_count_words_across_lines, :analyzers

  def initialize
    self.analyzers = Array.new
  end
  
  # Implement the following methods in the Solution class.
  #* analyze_file() - processes 'test.txt' intro an array of LineAnalyzers
  #* calculate_line_with_highest_frequency() - determines which line of
  #text has the highest number of occurrence of a single word
  #* print_highest_word_frequency_across_lines() - prints the words with the 
  #highest number of occurrences and their count
  def analyze_file #FUNCIONANDO \o/
    begin
      File.foreach('test.txt') do |line|
        self.analyzers << LineAnalyzer.new(line.chomp, $.)
      end
    rescue Exception => e
      puts e.message
    end
  end
  def calculate_line_with_highest_frequency # FUNCIONANDO \o/
    self.highest_count_words_across_lines = Array.new
    self.analyzers.max_by do |item|
      self.highest_count_across_lines = item.highest_wf_count
    end
    self.highest_count_words_across_lines += self.analyzers.select { |item| item.highest_wf_count == self.highest_count_across_lines }
  end
  
  # Implement the analyze_file() method() to:
  #* Read the 'test.txt' file in lines 
  #* Create an array of LineAnalyzers for each line in the file

  # Implement the calculate_line_with_highest_frequency() method to:
  #* calculate the highest number of occurences of a word across all lines
  #and stores this result in the highest_count_across_lines attribute.
  #* identifies the words that were used with the highest number of occurrences
  #and stores them in print_highest_word_frequency_across_lines.

  #Implement the print_highest_word_frequency_across_lines() method to
  #* print the result in the following format
  def print_highest_word_frequency_across_lines # Working!  \o/
    self.analyzers.each do |array_item|
      puts "#{array_item.highest_wf_words} (appears in line #{array_item.line_number})" if self.highest_count_across_lines == array_item.highest_wf_count
    end
  end
end
