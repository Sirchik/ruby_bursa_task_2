require 'active_support/all'
require 'pry'

require './author.rb'
require './book.rb'
require './published_book.rb'
require './reader.rb'
require './reader_with_book.rb'

class LibraryManager

  attr_accessor :reader_with_book, :issue_datetime

  def initialize reader_with_book, issue_datetime
    @reader_with_book = reader_with_book
    @issue_datetime = issue_datetime
  end

  def penalty
    hoursAgo = ((DateTime.now.new_offset(0) - issue_datetime).to_f * 24).round
    years_from_published = (DateTime.now.strftime("%Y").to_i - reader_with_book.book.published_at).floor
    res = if hoursAgo > 0
      ((0.00007 * years_from_published) + 
      (0.000003 * reader_with_book.book.pages_quantity) + 
      (0.0005)) * reader_with_book.book.price * hoursAgo
    else
      0
    end
    return res.round
  end

  def could_meet_each_other? first_author, second_author
    year_of_birth_first = first_author.year_of_birth
    year_of_death_first = first_author.year_of_death
    year_of_birth_second = second_author.year_of_birth
    year_of_death_second = second_author.year_of_death
    if year_of_birth_first > year_of_death_first || year_of_birth_second > year_of_death_second
      puts "Wrong dates!"
      return false
    end
    res = if (year_of_birth_first <= year_of_birth_second && year_of_death_first >= year_of_birth_second) ||
      (year_of_birth_second <= year_of_birth_first && year_of_death_second >= year_of_birth_first)
      true
    else
      false
    end
    return res
  end

  def days_to_buy
    years_from_published = (DateTime.now.strftime("%Y").to_i - reader_with_book.book.published_at).floor
    res = 1 / ((0.00007 * years_from_published) + 
      (0.000003 * reader_with_book.book.pages_quantity) + 
      (0.0005)) / 24
    return res.round
  end

  def transliterate author
    ukrArray = Array.[]("А", "Б", "В", "Г", "Ґ", "Д", "Е", "Є", "Ж", "З", "И", "І", "Ї", "Й", "К", "Л", "М", "Н",
    "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ю", "Я", "а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н",
    "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ю", "я")
    translitArray = Array.[]("A", "B", "V", "H", "G", "D", "E", "Ye", "Zh", "Z", "Y", "I", "Yi", "Y", "K", "L", "M", "N",
    "O", "P", "R", "S", "T", "U", "F", "Kh", "Ts", "Ch", "Sh", "Shch", "Yu", "Ya", "a", "b", "v", "h", "g", "d", "e", "ie", "zh", "z", "y", "i", "i", "i", "k", "l", "m", "n",
    "o", "p", "r", "s", "t", "u", "f", "kh", "ts", "ch", "sh", "shch", "iu", "ia")
    res = ""
    author.name.each_char {|c| res = res + (ukrArray.index(c) == nil ? c : translitArray[ukrArray.index(c)])}
    return res
  end

  def penalty_to_finish
    dtFinish = DateTime.now.new_offset(0) + reader_with_book.time_to_finish.hours
    years_from_published = (dtFinish.strftime("%Y").to_i - reader_with_book.book.published_at).floor
    res = dtFinish > issue_datetime ? ((0.00007 * years_from_published) + 
      (0.000003 * reader_with_book.book.pages_quantity) + 
      (0.0005)) * reader_with_book.book.price * ((dtFinish - issue_datetime).to_f * 24).round : 0
    return res.round
  end

  def email_notification_params
      {
        penalty: "some code",
        hours_to_deadline: "some code",
      }
  end

  def email_notification
    #use email_notification_params
  end

end
