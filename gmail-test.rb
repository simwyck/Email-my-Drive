require 'gmail'

# On se connect au compte Gmail. Mettez ici votre id avec @gmail.com et votre mdp.
@gmail = Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33")



@gmail = Mail.new do
  #from     'me@test.lindsaar.net'
  to       'thpslacker@gmail.com'
  subject  'Here is the image you wanted'
  text_part do
    body "Text of plaintext message.\n My second line."
  end
  html_part do
    content_type 'text/html; charset=UTF-8'
    body "<p>Text of <em>html</em> message.<br />My second line.</p>"
  end
end

@gmail.deliver!


# Se déconnecter
@gmail.logout
