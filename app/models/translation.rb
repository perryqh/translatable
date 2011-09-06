class Translation
  include ActiveModel::Validations
  extend TranslationStore

  attr_accessor :locale, :key, :value

  validates :locale, :length => {:minimum => 2}
  validates :key, :length => {:minimum => 1}

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def destroy
    Translation.send(:destroy, locale, key)
  end

  def to_key
    [@key]
  end

  def value
    unless @value.blank?
      if @value.first == "\""
        val = @value[1..-1]
      else
        val = @value
      end
      val = val[0..-2] if val.last == "\""
    end

    val || @value
  end

  def save
    if valid?
      Translation.send(:save, locale, key, value)
      true
    else
      false
    end
  end
end
