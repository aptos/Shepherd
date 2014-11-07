# This will guess the User class
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

  end
