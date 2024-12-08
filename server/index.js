const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

const users = {}; // 接続ユーザーを管理

app.get("/", (req, res) => {
	res.sendFile(__dirname + "/index.html");
});

io.on("connection", (socket) => {
	console.log("ユーザが接続しました");

	// ユーザーがニックネームを設定
	socket.on("set nickname", (nickname) => {
		users[socket.id] = nickname;
		io.emit("user list", Object.values(users));
		io.emit("chat message", `${nickname} が接続しました`);
	});

	socket.on("chat message", (msg) => {
		const nickname = users[socket.id] || '匿名';
		// メッセージを送信者以外にブロードキャスト
		socket.broadcast.emit("chat message", `${nickname}: ${msg}`);
		console.log("メッセージ: " + msg);
	});

	// タイピング通知
	socket.on("typing", (isTyping) => {
		const nickname = users[socket.id] || '匿名';
		socket.broadcast.emit("typing", `${nickname} is typing...`);
	});

	// プライベートメッセージ
	socket.on("private message", ({ to, message }) => {
		const nickname = users[socket.id] || '匿名';
		// 送信先のソケットを検索
		const targetSocket = Object.keys(users).find(key => users[key] === to);
		if (targetSocket) {
			io.to(targetSocket).emit("private message", `${nickname} (private): ${message}`);
		}
	});

	// 切断処理
	socket.on("disconnect", () => {
		const nickname = users[socket.id];
		delete users[socket.id];
		io.emit("user list", Object.values(users));
		if (nickname) {
			io.emit("chat message", `${nickname} が切断しました`);
		}
		console.log("ユーザが切断しました");
	});
});

server.listen(3000, () => {
	console.log("listening on *:3000");
});
