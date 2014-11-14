FactoryGirl.define do

	factory :admin do
    email "brian@taskit.io"
    name "Brian Wilkerson"
    credentials {{
      'token' => "ya29.tgBWkugGIHHikdLmiyUSvpPB3r8wYwe_05FOwVUKyJ7szLpKI-UlaubMXneofG7TmDyT6yDi4SeYdQ",
      'refresh_token' => "1/0EshJnMIEnbt2v0rTJgWRNG86KFLWneKVRCy4NDA5w4",
      'expires_at' => 1415304668
    }}
  end

  factory :ahoy_message, class: Ahoy::Message do
    token "E7W6COBWPACK3zBMqBlVG32jwOyNTrDF"
    to "bswilkerson@gmail.com"
    user_id "b156e09d3ee6d824ce469a3d2a28ad32"
    from "zoevollersen@gmail.com"
    mailer "Gmailer#standard_email"
    subject "Welcome to TaskIT"
    content "Date: Fri, 14 Nov 2014 14:27:34 -0800\r\nFrom: zoe vollersen <zoevollersen@gmail.com>\r\nTo: bswilkerson@gmail.com\r\nMessage-ID: <546681d68bd58_dfde3fe68205e6e8217d6@aptos.local.mail>\r\nSubject: Welcome to TaskIT\r\nMime-Version: 1.0\r\nContent-Type: text/html;\r\n charset=UTF-8\r\nContent-Transfer-Encoding: 7bit\r\n\r\n<!DOCTYPE html>\r\n<html>\r\n<head>\r\n  <meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\">\r\n</head>\r\n<body>\r\n  <p>\r\n    </p>\r\n<p>Hi Brian!</p>\r\n\r\n<p>We're really happy to have you</p>\r\n\r\n<p>Cheers,\r\n<br>Zoe</p>\r\n  \r\n<img height=\"1\" src=\"http://localhost:5000/ahoy/messages/E7W6COBWPACK3zBMqBlVG32jwOyNTrDF/open.gif\" width=\"1\">\r\n</body>\r\n</html>\r\n"
    mailservice_id "149b06b34a64fe26"
    sent_at "2014-11-14 23:36:53 UTC"
  end

end
