import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './new.dart';

class FocusSessionList extends StatelessWidget {
  const FocusSessionList({super.key});

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
            return ListTile(
              title: Text(focusSession.sessionDate!),
              // trailing: Row(children: [
              //   IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
              // ])
            );
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
