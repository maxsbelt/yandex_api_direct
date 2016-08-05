# Yandex API Direct

A lightweight and flexible library that wraps [Yandex Direct API](https://tech.yandex.ru/direct/) and allow you to use it in very easy and comfortable way. And, as a bonus, no additional dependencies :wink:

## How to install?

Just add this line to the Gemfile of your application:

```ruby
gem 'yandex_direct_api'
```

And run:

```
$ bundle install
```

Or install gem directly from rubygems.org:

```
$ gem install yandex_direct_api
```

## How to use API directly?

In simplest case you can call any method of the Yandex Direct API and pass any parameters like this:

```ruby
YandexDirectApi.call('campaigns.get')
```

But if you want to perform multiple calls it's good idea to create a wrapper object and use it:

```ruby
service =  YandexDirectApi.service
service.call('campaigns.get') # [{:uid=>3710412, ...}]
service.call('campaigns.get')
```

By default you are able to not specify `access_token`.  In this case only public methods will be available for call and `YandexDirectApi::MethodCallError` will be raised when you'll try to call some private method. If you want to call private methods you can specify `access_config` in global configuration:

```ruby
YandexDirectApi.configure do |config|
  config.access_token = ACCESS_TOKEN
end
```

And if you pass another one `access_token` as a parameter for `call` it wil be used instead of globally configured:

```ruby
YandexDirectApi.call('campaigns.get', :access_token => ANOTHER_ACCESS_TOKEN)
```

## Proxy object

It's very easy to make a mistake if you call methods by it's string names. That's why this gem provides a proxy object. You can use this object to call any methods of API as if it is a plain old ruby method:

```ruby
service =  YandexDirectApi.service
service.campaigns.get()
```

And again you can configure `access_token` globally or use it as a parameter:

```ruby
service =  YandexDirectApi.service
service.campaigns.get(:access_token => ACCESS_TOKEN)
```

## How to help the project?

As usual:

1. Create a fork
2. Add a branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push it (`git push origin my-new-feature`)
5. Make a pull request
