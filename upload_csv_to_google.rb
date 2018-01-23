# Décommentez la ligne suivante si vous voulez aussi générer le CSV. Sinon, on utilisera le CSV existant.
# require_relative 'scrapping'
require 'pry'
require 'google_drive'

# M'identifie chez Google via le fichier de config. Ca utilise mon compte Google fake.
session = GoogleDrive::Session.from_config("config.json")

# Uploads a local file.
#binding.pry
session.upload_from_file("mairies_gironde.csv", "Mairies Gironde (converted to Googgle Spreadsheet)", convert: true)

# file = session.file_by_title("mairies_gironde.csv")

# Downloads to a local file.
#file.download_to_file("/home/simwyck/Bureau/THP/J11/dl/hello.txt")

# Updates content of the remote file.
# file.update_from_file("mairies_gironde.csv")

p "Uploaded, man!"


# Note: Voir comment faire un update du même CSV plutôt que de le recréer: https://github.com/gimite/google-drive-ruby/blob/master/lib/google_drive/spreadsheet.rb
