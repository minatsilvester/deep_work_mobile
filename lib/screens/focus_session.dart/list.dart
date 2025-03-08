import 'package:deep_work_mobile/providers/auth_provider.dart';
import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './new.dart';
import '../../common/utils.dart';
import 'package:go_router/go_router.dart';

class FocusSessionList extends StatefulWidget {
  const FocusSessionList({super.key});

  @override
  FocusSessionListState createState() => FocusSessionListState();
}

class FocusSessionListState extends State<FocusSessionList> {
  @override
  Widget build(BuildContext context) {
    final focusSessionProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

    // focusSessionProvider.listFocusSessions(date: DateTime.now());

    Future<void> selectDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: focusSessionProvider.selectedDate,
          firstDate: DateTime(2024),
          lastDate: DateTime.now());

      if (pickedDate != null &&
          pickedDate != focusSessionProvider.selectedDate) {
        focusSessionProvider.updateSelectedDate(pickedDate);
        focusSessionProvider.listFocusSessions(date: pickedDate);
      }
    }

    void logout() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.logout();
    }

    void openNewFocusSessionFormModal() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          builder: (ctx) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: const NewFocusSessionForm(),
            );
          });
    }

    void showSummaryModal(BuildContext context) {
      final focusSessionProvider =
          Provider.of<FocusSessionProvider>(context, listen: false);
      final totalSessions = focusSessionProvider.focusSessions.length;
      final completedSessions = focusSessionProvider.focusSessions
          .where((session) => session.status == 'completed')
          .length;
      final completionPercentage =
          totalSessions > 0 ? (completedSessions / totalSessions) * 100 : 0;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Focus Session Summary"),
          content: Text(
            "Completed: $completedSessions / $totalSessions\n"
            "Completion Rate: ${completionPercentage.toStringAsFixed(2)}%",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Sessions'), actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          tooltip: 'Summary',
          onPressed: () => showSummaryModal(context),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => selectDate(context),
        ),
        IconButton(
            onPressed: () => {logout(), context.go('/')},
            icon: const Icon(Icons.logout))
      ]),
      body: Consumer<FocusSessionProvider>(builder: (context, provider, child) {
        if (focusSessionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (focusSessionProvider.isFailed) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cannot Retive Focus Sessions",
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
            ],
          ));
        }

        if (focusSessionProvider.focusSessions.isEmpty) {
          return const Center(child: Text('No Entries found'));
        }

        return ListView.builder(
          itemCount: focusSessionProvider.focusSessions.length,
          itemBuilder: (context, index) {
            final focusSession = focusSessionProvider.focusSessions[index];
            return InkWell(
                onTap: () {
                  context.push('/focus_sessions/${focusSession.id}');
                },
                child: Card(
                    color: setColor(focusSession.status!),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                focusSession.name!,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Expected Length: ${focusSession.expectedLength.toString()}',
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  "Start Time: ${formatDateTime(focusSession.startTime!)}"),
                              const SizedBox(height: 4),
                              Text(focusSession.status == 'inprogress'
                                  ? "Expected End Time: ${formatDateTime(focusSession.expectedEndTime!)}"
                                  : "End Time: ${formatDateTime(focusSession.expectedEndTime!)}")
                            ]))));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: openNewFocusSessionFormModal,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
