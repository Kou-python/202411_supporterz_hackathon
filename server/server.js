const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const groups = {}; // { groupId: { name: groupName, members: [] } }

io.on("connection", (socket) => {
	console.log(socket.id, "さんが入室しました");

	// グループ作成
	socket.on("createGroup", (groupName, callback) => {
		const groupId = Math.floor(10000 + Math.random() * 90000); // 5桁の乱数
		if (groups[groupId]) {
			callback({ success: false, message: "グループ作成に失敗しました。" });
		} else {
			groups[groupId] = { name: groupName, members: [] };
			callback({ success: true, message: "グループを作成しました。", groupId });
			console.log(`グループ作成: ${groupName} (ID: ${groupId})`);
		}
	});

	// グループ参加
	socket.on("joinGroup", (groupId, userName, callback) => {
		const group = groups[groupId];
		if (!group) {
			callback({ success: false, message: "グループが見つかりません。" });
		} else {
			group.members.push(userName);
			callback({ success: true, message: "グループに参加しました。", groupName: group.name });
			socket.join(groupId.toString()); // ソケットをグループルームに参加
			console.log(`${userName} さんがグループ(${groupId})に参加しました。`);

			// 他のメンバーに通知
			io.to(groupId.toString()).emit("userJoined", { userName, groupName: group.name });
		}
	});

	// グループ退室
	socket.on("leaveGroup", (groupId, userName, callback) => {
		const group = groups[groupId];
		if (group) {
			group.members = group.members.filter((name) => name !== userName);
			callback({ success: true, message: "グループから退室しました。" });
			socket.leave(groupId.toString());
			console.log(`${userName} さんがグループ(${groupId})から退室しました。`);
		} else {
			callback({ success: false, message: "退室に失敗しました。" });
		}
	});

	// チャットメッセージ送信
	socket.on("chat message", ({ groupId, msg }) => {
		console.log(`グループ(${groupId}) - ${socket.id}: ${msg}`);
		io.to(groupId.toString()).emit("chat message", { userId: socket.id, msg });
	});

	// 接続終了
	socket.on("disconnect", () => {
		console.log(socket.id, "さんが退室しました");
	});
});

server.listen(3000, () => {
	console.log("Server is running on http://localhost:3000");
});
