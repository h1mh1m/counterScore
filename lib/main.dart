import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Penghitung Score",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: ScoreHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScoreHomePage extends StatefulWidget {
  const ScoreHomePage({super.key});

  @override
  State<ScoreHomePage> createState() => ScoreHomePageState();
}

class ScoreHomePageState extends State<ScoreHomePage> {
  int scoreTeamSatu = 0;
  int scoreTeamDua = 0;
  String TeamSatu = "Team 1";
  String TeamDua = "Team 2";
  int MaxNilai = 10; //default value
  final TextEditingController MaxControllerScore = TextEditingController(
    text: "10",
  );

  void incrementScoreTeamSatu() {
    setState(() {
      if (scoreTeamSatu < MaxNilai) scoreTeamSatu++;
      checkWinner();
    });
  }

  void incrementScoreTeamDua() {
    setState(() {
      if (scoreTeamDua < MaxNilai) scoreTeamDua++;
      checkWinner();
    });
  }

  void resetScore() {
    setState(() {
      scoreTeamDua = 0;
      scoreTeamSatu = 0;
    });
  }

  void editTeamName(bool isTeamSatu) {
    final controller = TextEditingController(
      text: isTeamSatu ? TeamSatu : TeamDua,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ubah ${isTeamSatu ? 'nama Team 1' : 'nama Team 2'}"),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: "Nama tim",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  if (isTeamSatu) {
                    TeamSatu = name;
                  } else {
                    TeamDua = name;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void checkWinner() {
    setState(() {
      if (scoreTeamSatu == MaxNilai && scoreTeamSatu > scoreTeamDua) {
        WinnerDialog(TeamSatu);
      } else if (scoreTeamDua == MaxNilai && scoreTeamDua > scoreTeamSatu) {
        WinnerDialog(TeamDua);
      }
    });
  }

  void WinnerDialog(String team) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pertandingan Selesai"),
        content: Text("$team Memenangkan Pertandingan"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetScore();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  void updateMaxScore() {
    int? parsed = int.tryParse(MaxControllerScore.text);
    if (parsed != null && parsed > 0) {
      setState(() {
        MaxNilai = parsed;
        resetScore();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Maksimal skor $MaxNilai ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Penghitung Skor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Text(
                      "Max Score  ",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: MaxControllerScore,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: updateMaxScore,
                      child: const Text("Set"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            TeamSatu,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            tooltip: "Ubah nama Team 1",
                            onPressed: () => editTeamName(true),
                            icon: const Icon(Icons.edit, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$scoreTeamSatu',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: incrementScoreTeamSatu,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah"),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "VS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            TeamDua,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            tooltip: "Ubah nama Team 2",
                            onPressed: () => editTeamName(false),
                            icon: const Icon(Icons.edit, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$scoreTeamDua',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: incrementScoreTeamDua,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            if (scoreTeamSatu >= MaxNilai || scoreTeamDua >= MaxNilai)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: resetScore,
                label: const Text("Reset Nilai"),
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
      ),
    );
  }
}
