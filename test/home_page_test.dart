import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:noting/models/note_model.dart';
import 'package:noting/view/home_page.dart';
import 'package:path_provider/path_provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');
  testWidgets('HomePage should display notes', (WidgetTester tester) async {
  // create some notes for testing
  final notes = 
  [     
     NotesModel(title: 'Note 1', description: 'Description 1'),   
     NotesModel(title: 'Note 2', description: 'Description 2'),     
     NotesModel(title: 'Note 3', description: 'Description 3'),   
  ];

  // initialize the data in the box
  final box = Hive.box<NotesModel>('notes');
  await box.putAll(Map.fromIterable(notes, key: (note) => note.title));

  // build the widget tree
  await tester.pumpWidget(const MaterialApp(home: HomePage()));

  // verify that the notes are displayed in the list
  expect(find.text('Note 1'), findsOneWidget);
  expect(find.text('Note 2'), findsOneWidget);
  expect(find.text('Note 3'), findsOneWidget);
});


  testWidgets('HomePage should delete notes', (WidgetTester tester) async {
    // create a note for testing
    final note = NotesModel(title: 'Note', description: 'Description');
    // initialize the data in the box
    final box = await Hive.openBox<NotesModel>('notes');
    await box.put(note.title, note);
    // build the widget tree
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
  // tap the delete icon
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pumpAndSettle(); // Wait for the widget tree to settle
  // verify that the note is deleted
  expect(find.text('Note'), findsNothing);
  // display a success message
  expect(find.text('Note deleted successfully!'), findsOneWidget);
  });

  testWidgets('HomePage should edit notes', (WidgetTester tester) async {
    // create a note for testing
    final note = NotesModel(title: 'Note', description: 'Description');
    // initialize the data in the box
    final box = await Hive.openBox<NotesModel>('notes');
    await box.put(note.title, note);
    // build the widget tree
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    // tap the edit icon
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    // enter new text in the dialog
    await tester.enterText(find.byType(TextFormField), 'New Note');
    await tester.enterText(find.byType(TextFormField), 'New Description');
    // tap the save button
    await tester.tap(find.text('Save'));
    await tester.pump();
    // verify that the note is updated
    expect(find.text('New Note'), findsOneWidget);
    expect(find.text('New Description'), findsOneWidget);
  });
}
