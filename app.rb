require 'roda'
require 'rom'


ROM.setup(:memory)

class Artist
  attr_reader :id, :name

  def initialize(attrs)
    @id, @name = attrs.values_at(:id, :name)
  end
end

class Artists < ROM::Relation[:memory]
  base_name :artists # Table name.

  def by_id(id)
    restrict(id: id)
  end
end

class ArtistMapper < ROM::Mapper
  relation :artists

  model Artist

  attribute :id
  attribute :name
end

class UpdateArtist < ROM::Commands::Update[:memory]
  relation :artists
  register_as :update
end

class DeleteArtist < ROM::Commands::Delete[:memory]
  relation :artists
  register_as :delete
end

ROM.finalize


ROM.env.relations.artists << { id: 1, name: 'Jane' }


class App < Roda
  plugin :all_verbs
  #plugin :rom # Would define rom() to get the default ROM.env.

  rom = ROM.env

  route do |r|

    r.root do
      view :index
    end

    r.is 'artist/:id' do |artist_id|
      artist_id = artist_id.to_i
      artist = rom.read(:artists).by_id(artist_id)

      r.get do
        "Artist: #{artist.first.name}\n"
      end

      r.post do
        name = r['name']
        rom.command(:artists).try { update(:by_id, artist_id).set(name: name) }
        r.redirect
      end

      r.delete do
        # This is a low-level way to delete without creating a command.
        #artist_tuple = rom.relations.artists.by_id(artist_id).first
        #rom.relations.artists.delete(artist_tuple)

        rom.command(:artists).try { delete(:by_id, artist_id) }
        r.redirect '/'
      end
    end
  end

end

