import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/utils.dart';
import 'dart:async';
import 'dart:developer';

class ShowFocusSession extends StatefulWidget {
  final String id;

  const ShowFocusSession({super.key, required this.id});

  @override
  ShowFocusSessionState createState() => ShowFocusSessionState();
}

class ShowFocusSessionState extends State<ShowFocusSession> {
  Duration? remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  void _startCountDown() {
    final focusSession =
        Provider.of<FocusSessionProvider>(context, listen: false)
            .getFocusSession(widget.id);

    if (focusSession != null) {
      DateTime endTime = DateTime.parse(focusSession.expectedEndTime!);
      DateTime now = DateTime.now();
      Duration difference = endTime.difference(now);

      setState(() {
        remainingTime = difference.isNegative ? Duration.zero : difference;
      });

      if (!difference.isNegative) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (remainingTime == null) return; // Safety check

          setState(() {
            remainingTime = remainingTime! - const Duration(seconds: 1);

            if (remainingTime!.isNegative) {
              remainingTime = Duration.zero;
              _timer?.cancel();

              // ✅ Prevent setting "completed" if status is "cancelled"
              final updatedSession =
                  Provider.of<FocusSessionProvider>(context, listen: false)
                      .getFocusSession(widget.id);

              if (updatedSession != null &&
                  updatedSession.status == 'inprogress') {
                Provider.of<FocusSessionProvider>(context, listen: false)
                    .stopFocusSession(widget.id, 'completed')
                    .then((response) => {
                          if (response["status"]) {log("Success")}
                        });
              }
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final focusSession =
    //     Provider.of<FocusSessionProvider>(context, listen: false)
    //         .getFocusSession(widget.id);
    final provider =
        context.watch<FocusSessionProvider>(); // 👈 Listens for changes
    final focusSession = provider.getFocusSession(widget.id);

    return Scaffold(
        appBar: AppBar(title: const Text("Focus Session Details")),
        body:
            Consumer<FocusSessionProvider>(builder: (context, provider, child) {
          if (focusSession == null) {
            return const Center(child: Text('Data not found'));
          }

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(focusSession.name!,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(31, 135, 233, 1))),
                    // const SizedBox(height: 10),
                    Text(capitalize('${focusSession.status}'),
                        style:
                            TextStyle(color: setColor(focusSession.status!))),
                    const SizedBox(height: 10),
                    // Text(
                    //     'Start time: ${formatDateTime(focusSession.startTime!)}',
                    //     style: const TextStyle(fontSize: 18)),
                    // Text(
                    //     'Expected End Time: ${formatDateTime(focusSession.expectedEndTime!)}',
                    //     style: const TextStyle(fontSize: 18)),
                    // Text('Expected Length: ${focusSession.expectedLength}',
                    //     style: const TextStyle(fontSize: 18)),
                    Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_circle_fill,
                                color: Colors.greenAccent, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              formatDateTime(focusSession.startTime!),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.hourglass_bottom,
                                color: Colors.redAccent, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              formatDateTime(focusSession.expectedEndTime!),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        if (focusSession.status == 'completed') ...[
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.access_time_filled,
                                  color: Colors.redAccent, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                formatDateTime(focusSession.endTime!),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timelapse,
                                color: Colors.yellowAccent, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '${focusSession.expectedLength}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        if (isFocusSessionCompleted(focusSession)) ...[
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer,
                                  color: Colors.yellowAccent, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${focusSession.actualLength}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: remainingTime == null
                          ? const CircularProgressIndicator() // Show loading state until initialized
                          : remainingTime == Duration.zero
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: focusSession.status == "cancelled"
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                  ),
                                  child: Center(
                                    child: Icon(
                                        focusSession.status == "cancelled"
                                            ? Icons
                                                .close // Show ❌ when cancelled
                                            : Icons.check, // ✅ when completed
                                        size: 80,
                                        color: Colors.white),
                                  ),
                                )
                              : Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${(remainingTime!.inHours).toString().padLeft(2, '0')}:"
                                      "${(remainingTime!.inMinutes % 60).toString().padLeft(2, '0')}:"
                                      "${(remainingTime!.inSeconds % 60).toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                    ),
                    if (focusSession.status == "inprogress") ...[
                      const SizedBox(height: 30),
                      Center(
                        // Ensures button is horizontally centered
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Red background
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FocusSessionProvider>(context,
                                    listen: false)
                                .stopFocusSession(widget.id, 'cancelled')
                                .then((response) {
                              if (response["status"]) {
                                setState(() {
                                  remainingTime = Duration.zero; // Reset timer
                                });
                              }
                            });
                          },
                          child: const Text(
                            "Cancel Focus Session",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ]));
        }));
  }
}
