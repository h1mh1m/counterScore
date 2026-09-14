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
  int MaxNilai = 10;
  bool isDeuceAktif = false; // toggle deuce
  final TextEditingController MaxControllerScore = TextEditingController(
    text: "10",
  );

  void incrementScoreTeamSatu() {
    setState(() {
      bool deuce = isDeuceAktif &&
          scoreTeamSatu >= MaxNilai &&
          scoreTeamDua >= MaxNilai;
      if (scoreTeamSatu < MaxNilai || deuce) scoreTeamSatu++;
      checkWinner();
    });
  }

  void incrementScoreTeamDua() {
    setState(() {
      bool deuce = isDeuceAktif &&
          scoreTeamSatu >= MaxNilai &&
          scoreTeamDua >= MaxNilai;
      if (scoreTeamDua < MaxNilai || deuce) scoreTeamDua++;
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
    if (isDeuceAktif) {
      // Mode deuce aktif
      bool deuce = scoreTeamSatu >= MaxNilai && scoreTeamDua >= MaxNilai;
      if (deuce) {
        // Harus unggul 2 poin
        if ((scoreTeamSatu - scoreTeamDua).abs() >= 2) {
          String winner =
              scoreTeamSatu > scoreTeamDua ? TeamSatu : TeamDua;
          WinnerDialog(winner);
        }
      } else {
        if (scoreTeamSatu == MaxNilai && scoreTeamSatu > scoreTeamDua) {
          WinnerDialog(TeamSatu);
        } else if (scoreTeamDua == MaxNilai &&
            scoreTeamDua > scoreTeamSatu) {
          WinnerDialog(TeamDua);
        }
      }
    } else {
      // Mode normal tanpa deuce
      if (scoreTeamSatu == MaxNilai && scoreTeamSatu > scoreTeamDua) {
        WinnerDialog(TeamSatu);
      } else if (scoreTeamDua == MaxNilai && scoreTeamDua > scoreTeamSatu) {
        WinnerDialog(TeamDua);
      }
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Maksimal skor $MaxNilai")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cek kondisi deuce sedang terjadi
    bool isDeuceTerjadi = isDeuceAktif &&
        scoreTeamSatu >= MaxNilai &&
        scoreTeamDua >= MaxNilai;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Penghitung Skor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Card Max Score ---
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Baris Max Score
                    Row(
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

                    const Divider(height: 20),

                    // Baris Toggle Deuce
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mode Deuce",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isDeuceAktif
                                  ? "Aktif — harus unggul 2 poin"
                                  : "Nonaktif",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDeuceAktif
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: isDeuceAktif,
                          activeColor: Colors.amber,
                          onChanged: (value) {
                            setState(() {
                              isDeuceAktif = value;
                              resetScore();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Banner DEUCE! ---
            if (isDeuceTerjadi)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: const Text(
                  "⚡ DEUCE! Harus unggul 2 poin untuk menang!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),

            // --- Papan Skor ---
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
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: isDeuceTerjadi
                              ? Colors.amber
                              : Colors.blueAccent,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "VS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDeuceTerjadi ? Colors.amber : Colors.white70,
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
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: isDeuceTerjadi
                              ? Colors.amber
                              : Colors.blueAccent,
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

            // --- Tombol Reset ---
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