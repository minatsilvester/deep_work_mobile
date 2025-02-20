import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './new.dart';
import '../../common/utils.dart';

class FocusSessionList extends StatelessWidget {
  const FocusSessionList({super.key});

  Color setColor(String status) {
    switch (status) {
      case 'inprogress':
        return const Color.fromARGB(255, 185, 167, 9);
      case 'cancelled':
        return const Color.fromARGB(255, 159, 26, 17);
      case 'completed':
        return Colors.green;
      default:
        return const Color.fromARGB(255, 185, 167, 9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusSessionProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

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

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Sessions')),
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
            return Card(
                color: setColor(focusSession.status!),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        ])));
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
