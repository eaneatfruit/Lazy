#! /usr/bin/env python
import argparse
import slackweb
import socket

slackUrl = "INSERT URL"
autossh_beacon = "127.0.0.1:11211"

slack = slackweb.Slack(url=slackUrl)
message = "autossh beacon live on root@127.0.0.1: {}".format(autossh_beacon)
slack.notify(text=message)
