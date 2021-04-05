defmodule Proj4Test do
  use ExUnit.Case
  doctest Proj4
  @server_name String.to_atom("server@127.0.0.1")

  setup_all do
    Node.start (@server_name)
    Node.set_cookie :proj4
    Proj4.ServerSupervisor.start()
    list = Proj4.ClientSupervisor.start(10,1)
    GenServer.call({:MyServer,@server_name},{:set_state,list,10,1})
    Proj4.ClientNode.create_account(list,10,1)
    :ok
  end

  test "register user" do
    GenServer.call({:MyServer,@server_name},{:create_account,self()})
    result = Proj4.Server.register_account(self())
    assert result == true
  end

  test "login check" do
    GenServer.call({:MyServer,@server_name},{:create_account,self()})
    result = Proj4.Server.user_logged_in(self())
    assert result == true
    Proj4.Server.logout(self())
    result = Proj4.Server.isLoggedOut(self())
    assert result == true
  end

  test "send tweet" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.take_random(pid,2)
    GenServer.call({:MyServer,@server_name},{:create_account,self()})
    GenServer.call({:MyServer,@server_name},{:subscribe,self(),subscribers})
    tweet = "testing123"
    GenServer.cast({:MyServer,@server_name},{:send_tweet,self(),tweet})
    feed = GenServer.call({:MyServer,@server_name},{:get_tweets,self()})
    assert Enum.member?(feed,tweet)
  end

  test "check if tweet sent to followers" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    tweet = "Testing1234"
    GenServer.cast({:MyServer,@server_name},{:send_tweet,subscribers,tweet})
    following = GenServer.call({:MyServer,@server_name},{:get_following,subscribers})
    following = Enum.random(following)
    feed = GenServer.call({:MyServer,@server_name},{:get_feed,following})
    assert Enum.member?(feed,tweet)
  end

  test "send tweets with hashtag" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    tweet = "Testing1234#COP5615 is great"
    hashtag = "#COP5615 is great"
    GenServer.cast({:MyServer,@server_name},{:send_tweet,subscribers,tweet})
    tweet_with_hashtag = GenServer.call({:MyServer,@server_name},{:get_hashtags,hashtag})
    assert Enum.member?(tweet_with_hashtag,tweet)
  end

  test "send tweets with mention" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    mention = Enum.random(pid)
    tweet = "Test tweet"<>inspect(mention)
    GenServer.cast({:MyServer,@server_name},{:send_tweet_with_mention,subscribers,tweet,mention})
    tweets = GenServer.call({:MyServer,@server_name},{:get_mentions,mention})
    assert Enum.member?(tweets,tweet)
  end

  test "retweet" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    tweet = "Testing1234"
    GenServer.cast({:MyServer,@server_name},{:send_tweet,subscribers,tweet})
    following = GenServer.call({:MyServer,@server_name},{:get_following,subscribers})
    following = Enum.random(following)
    feed = GenServer.call({:MyServer,@server_name},{:get_feed,following})
    tweet = Enum.random(feed)
    tweet = "RT"<>tweet
    GenServer.cast({:MyServer,@server_name},{:send_tweet,following,tweet})
    feed = GenServer.call({:MyServer,@server_name},{:get_tweets,following})
    assert Enum.member?(feed,tweet)
  end
  
  test "query tweet with hashtag" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    tweet = "Testing1234#COP5615 is great"
    hashtag = "#COP5615 is great"
    GenServer.cast({:MyServer,@server_name},{:send_tweet,subscribers,tweet})
    tweet_with_hashtag = GenServer.call({:MyServer,@server_name},{:get_hashtags,hashtag})
    assert Enum.member?(tweet_with_hashtag,tweet)
  end

  test "query tweet with mention" do
    pid = GenServer.call({:MyServer,@server_name},{:get_users})
    subscribers = Enum.random(pid)
    mention = Enum.random(pid)
    tweet = "Test tweet"<>inspect(mention)
    GenServer.cast({:MyServer,@server_name},{:send_tweet_with_mention,subscribers,tweet,mention})
    tweets = GenServer.call({:MyServer,@server_name},{:get_mentions,mention})
    assert Enum.member?(tweets,tweet)
  end
end
