class Hashie::Mash
  def self.loose(array_or_hash)
    if Array === array_or_hash
      array_or_hash.map { |item| Hashie::Mash[item] }
    else
      Hashie::Mash[array_or_hash]
    end
  end
end
