# Класс для обработки ФИО.
class Fio < Virtus::Attribute
  def coerce(value)
    return value unless value.is_a?(String)

    value.split(' ').map { |str1| str1.split('-').map { |str2| str2[0].upcase + str2[1..-1].downcase }.join('-') }.join(' ')
  end
end
