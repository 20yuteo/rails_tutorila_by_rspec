FactoryBot.define do

    factory :orange, class: Micropost do
        content { "I just ate an orange!" }
        created_at  { 10.minutes.ago}
    end

    factory :tau_manifesto, class: Micropost do
        content { "Check out the @tauday site by @mhartl: http://tauday.com" }
        created_at { 3.years.ago }
    end

    factory :cat_video, class: Micropost do
        content { "Sad cats are sad: http://youtu.be/PKffm2uI4dk" }
        created_at { 2.hours.ago }
    end

    factory :most_recent, class: Micropost do
        content { "Writing a short test" }
        created_at { Time.zone.now }
    end

    factory :micropost do
        content { "Lorem ipsum" }
    end
end