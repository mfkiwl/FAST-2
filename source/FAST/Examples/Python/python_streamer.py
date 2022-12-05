import fast
import os
import numpy as np
from time import sleep

#fast.Reporter.setGlobalReportMethod(fast.Reporter.COUT)
fast.downloadTestDataIfNotExists()

class MyStreamer(fast.PythonStreamer):
    """
    A simple FAST streamer which runs in its own thread.
    """

    def __init__(self):
        super().__init__()
        self.createOutputPort(0)

    def generateStream(self):
        """
        This method runs in its own thread.
        Run you streaming loop here.
        Remember to call self.addOutputData and self.frameAdded for each frame.
        If these calls return and exception, it means the streaming should stop, thus you need to exit
        your streaming loop
        """
        path = fast.Config.getTestDataPath() + '/US/Heart/ApicalFourChamber/US-2D_#.mhd'
        frame = 0
        while True:
            print('Streaming', frame)
            filepath = path.replace('#', str(frame))
            if not os.path.exists(filepath):
                # No more frames on disk, restart streaming loop
                frame = 0
                continue

            # Read frame from disk
            importer = fast.ImageFileImporter.create(filepath)
            image = importer.runAndGetOutputData()

            try:
                self.addOutputData(0, image)
                self.frameAdded() # Important to notify any listeners
                sleep(0.02)
            except:
                # Streaming has been requested to stop. Thus we break the while loop
                break
            frame += 1


""" A python process object which simply inverts an image with numpy """
class Inverter(fast.PythonProcessObject):
    def __init__(self):
        super().__init__()
        self.createInputPort(0)
        self.createOutputPort(0)

    def execute(self):
        # Get image and invert it with numpy
        image = self.getInputData()
        np_image = np.asarray(image)
        np_image = 255 - np_image # invert

        # Create new fast image and add as output
        new_output_image = fast.Image.createFromArray(np_image)
        new_output_image.setSpacing(image.getSpacing())
        self.addOutputData(0, new_output_image)


# Setup processing chain and run
streamer = MyStreamer.create()

inverter = Inverter.create().connect(streamer)

renderer = fast.ImageRenderer.create().connect(inverter)

fast.SimpleWindow2D.create().connect(renderer).run()