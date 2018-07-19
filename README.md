# wow-smart-recruitment-macro
A decentralized WoW guild recruitment macro which doesn't suck - the GM updates it, it spreads to everyone.

**The addon worked in Legion, it might require extra work to port it to BFA**

## Warning

This addon is from my old guild Euphorie, hence the name, `RecrutementEuphorie`. Also, it's in french, deal with it.

**Do not use this if you don't trust your players.** It's easy to spoof the authority and mess with the addon. A nice example of that is [the story of H4CK3RM4N](https://www.reddit.com/user/natinusala/comments/826vyz/the_story_of_h4ck3rm4n_or_how_i_lifted_the/) ( ͡° ͜ʖ ͡° )

## How does this work ?

Each copy of the addon keeps the current macro message locally. One guy (the "authority") is in charge and can update it, he's the only one allowed to do so.

As soon as a player comes online with an outdated messages, it grabs the latest available from the online guildmates. As soon as a player comes online, their message is spread to every other players in case their copy of the message is outdated.

This allow authorities to update the message from a nice GUI, and it will spread gently across all players as they come online. No pain, no hassle, always up to date.

## Usage

0. Edit the addon (`main.lua`, line 5) to change the authority name
1. Share the addon to all your players
2. Upon installation, the addon will create a macro, click on it to post the message in your /2
3. The authority can now use `/reupdate` to open a GUI and update the current message

## Commands

* `/reupdate` (authority only) update the message
* `/remessage`, `/rerevision` : show the current message or revision
