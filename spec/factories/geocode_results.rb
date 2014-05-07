# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :geocode_result, :class => 'GeocodeResults' do
    point ""
    date "2014-05-06"
    created_at "2014-05-06 15:16:29"
    updated_at "2014-05-06 15:16:29"
  end
end
