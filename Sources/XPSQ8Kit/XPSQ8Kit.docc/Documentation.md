# Getting Started

Connect to your XPS-Q8 instrument.

## Overview

The first step in communicating with your instrument is to connect to it. This article will walk you though connecting to your instrument over ethernet.

### Setup

First you will need to power up your instrument and connect it through ethernet to your computer. You should test that you are connected to the instrument by typing in your instrument's IP address in Safari. You should see a login screen if your instrument is successfully connected.

### Connecting

You will communicate with your instrument though an ``XPSQ8Controller`` instance. To connect to your instrument, initialize an ``XPSQ8Controller`` with your instruments IP and port number (the default port number is `5001`):

```swift
do {
  let controller = try XPSQ8Controller(address: "192.168.0.254", port: 5001)
} catch {
  // There was an error connecting to the instrument
}
```

You can also specify a custom timeout value for connecting to and communicating with your instrument:

```swift
do {
  // Specify the timeout in seconds (here the timeout is set to 10 seconds)
  let controller = try XPSQ8Controller(address: "192.168.0.254", port: 5001, timeout: 10)
} catch {
  // There was an error connecting to the instrument
}
```

### Logging in

You may need to login to your instrument depending on your configuration. This can be done by calling ``XPSQ8Controller/login(username:password:)``. All commands on the controller are async, so you will need to call them from an async context. If you are not in an async context, the easiest way to call it is to place it in a task block. All commands on the controller are also throwing, since the communication can fail at any time:

```swift
Task {
  do {
    try await controller.login(username: "Admin", password: "pa55w0rd")
  } catch {
    // Could not login
    // Can error from wrong user/password, or if there is an error communicating with the instrument
  }
}
```

### Status

After connecting to your instrument, you can check the status of the instrument at any time. This is done by calling ``XPSQ8Controller/status-swift.property``. This returns a ``XPSQ8Controller/Status-swift.struct`` with an integer ``XPSQ8Controller/Status-swift.struct/code``. To get a string description of a status, you can call ``XPSQ8Controller/statusString(of:)``:

```swift
Task {
  // Prints a description of the current status
  let status = try await controller.status
  let statusDescription = try await controller.statusString(of: status)
  print(statusDescription)
}
```

You can reset the status of the instrument at any time by calling ``XPSQ8Controller/resetStatus()``. This will return the current status and reset the controller status flag:

```swift
Task {
  let currentStatus = try await controller.resetStatus()
  print(currentStatus)
}
```
