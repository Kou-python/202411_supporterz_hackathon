import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GroupScreen(),
    );
  }
}

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late IO.Socket socket;
  List<String> messages = [];
  String? currentGroupId;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Socket.IO設定
    socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    // イベントリスナー
    socket.on('groupCreated', (data) {
      setState(() {
        currentGroupId = data['groupId'];
        messages.add("グループ作成: ${data['groupName']} (ID: ${data['groupId']})");
      });
    });

    socket.on('joinedGroup', (data) {
      setState(() {
        currentGroupId = data['groupId'];
        messages.add("グループ参加: ${data['groupName']}");
      });
    });

    socket.on('chat message', (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void createGroup(String groupName) {
    socket.emit('createGroup', groupName);
  }

  void joinGroup(String groupId) {
    socket.emit('joinGroup', {'groupId': groupId});
  }

  void leaveGroup() {
    if (currentGroupId != null) {
      socket.emit('leaveGroup', {'groupId': currentGroupId});
      setState(() {
        messages.add("グループ退室: $currentGroupId");
        currentGroupId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("グループチャット"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: groupNameController,
                        decoration: InputDecoration(hintText: "グループ名を入力"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (groupNameController.text.isNotEmpty) {
                          createGroup(groupNameController.text);
                        }
                      },
                      child: Text("作成"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: groupIdController,
                        decoration: InputDecoration(hintText: "グループIDを入力"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (groupIdController.text.isNotEmpty) {
                          joinGroup(groupIdController.text);
                        }
                      },
                      child: Text("参加"),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: leaveGroup,
                  child: Text("退室"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          )
        ],
      ),
    );
  }
}
