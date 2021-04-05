# Twitter-Simulator
A distributed engine for a twitter-like application with Phoenix and Elixir and a simulations of its performance with varying number of concurrent connections using concurrent actors as independent nodes. Supported features such as tweeting, retweeting and live querying of tweets. Written in Elixir, using the Phoenix framework.

# Instructions to run the simulator
1. Run the following command to start the server – mix run application.exs server
2. Now, open another terminal in the extracted folder and run the following command for starting the clients- mix run application.exs <numUsers> <numMessages>
3. Once all the activities have been performed, the server will display performance statistics

# Functionalities implemented
1. Register account – when a user requests the server to be added to the network, the server registers the user.
2. Generate followers - from the list of users present, each client chooses a random number of accounts to follow. Once decided, it sends this list of followers to the server, who follows the accounts on the client’s behalf.
3. Send tweets – the user chooses a random tweet(string) from the list of pre-defined strings present in the system. This tweet is sent to the server, which then publishes the tweet to all the user’s followers.
4. Send tweets with hashtag/mentions - the user chooses a random tweet(string) from the list of pre-defined strings present in the system. The user also chooses a random hashtag or user to mention in the tweet. This tweet is sent to the server, which then publishes the tweet to all the user’s followers. Also, this tweet in the hashtags table for further querying.
5. Retweets – if a user happens to like a tweet in their feed, they may choose to re-tweet that tweet to their followers. All retweets are appended with the string “RT” at the beginning.
6. Query tweets- the user may choose to query their own tweets, some other user’s tweets, tweets with a hashtag or tweets with a mention. The server will reply to the query with the appropriate response.

# System Architecture
1. Server – The server has been implemented using a GenServer. When the server is started under the supervision tree, it initializes seven (7) ETS tables – accounts, followers, following, tweets, feed, hashtags, mentions. These tables take in the PID of the client process as the key. The server is the only process allowed to access these tables. The client sends various requests to the server, such as send_tweet, retweet, get_feed etc. The server updates the values of tables when the appropriate request is sent. The server also keeps a count of the activities it performs it log the performance statistics.
2. Client: A separate GenServer is created for each client in the system. The user ID for each client is its corresponding PID. The client makes requests to the server, which are fulfilled by the server. The client terminal will display the result of any query, such as read_feed, query_hashtags etc. Once a client has sent the number of tweets as mentioned in the numMessages argument of the input, it will stop sending any further tweets.

# Performance Statistics
1. Number of users = 10, Number of activities = 162, Number of activities per second = 36.1
2. Number of users = 50, Number of activities = 685, Number of activities per second = 67.2
3. Number of users = 100, Number of activities = 1412, Number of activities per second = 301
4. Number of users = 200, Number of activities = 4174, Number of activities per second = 500
5. Number of users = 300, Number of activities = 4910, Number of activities per second = 550
6. Number of users = 400, Number of activities = 7722, Number of activities per second = 365
7. Number of users = 500, Number of activities = 10547, Number of activities per second = 313
