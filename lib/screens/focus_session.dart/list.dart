import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FocusSessionList extends StatelessWidget {
  const FocusSessionList({super.key});

  @override
  Widget build(BuildContext context) {
    final focusSessionProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

    final String? message =
        ModalRoute.of(context)!.settings.arguments as String?;

    if (message != null && message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
