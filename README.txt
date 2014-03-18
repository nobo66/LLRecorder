What is LLRecorder?
-------------------
LLRecorder(Language Learning Recorder) is a simple audio recorder for 
language learning.
The user can record one sentence repeatedly with different file name. 
The name of the saved file is "UserSpecifiedName + _ + Number + .extension".
UserSpecifiedName can be set in "file name" field in LLRecorder app.
Number is automatically incremented when start recording.
extension is automatically added according to the audio format.


System requirements
-------------------
Qt5.2.0 or later


Build and run
-------------
- open src/LLRecorderProjects.pro by Qt Creator.
- select build->build LLRecorderProjects project(Ctrl+B).
- select build->run(Ctrl+R).


Questions/Issues/Comments
-------------------------
Questions, Issues and Comments can be emailed to 
noboru.murakami@gmail.com


Known issues
------------
- When close app after play audio, the app crashes on Mac.
  This issue is probably related to the following issue.
  https://bugreports.qt-project.org/browse/QTBUG-34213


Revision history
----------------
- Version 1.00
  Initial release.
