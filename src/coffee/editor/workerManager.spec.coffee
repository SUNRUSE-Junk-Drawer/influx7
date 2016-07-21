describe "editor", -> describe "workerManager", ->
    rewire = require "rewire"
    describe "imports", ->
    describe "on calling cancel", ->
        document = element = editorCompilationStarted = editorCompilationFailed = editorCompilationCompleted = workers = Worker = editorWorkerManager = undefined
        beforeEach ->
            editorWorkerManager = rewire "./workerManager"
            document = 
                getElementById: (id) ->
                    (expect id).toEqual "Code"
                    element
            element = 
                value: "test code a"
            editorWorkerManager.__set__ "document", document
            editorCompilationStarted = jasmine.createSpy "editorCompilationStarted"
            editorWorkerManager.__set__ "editorCompilationStarted", editorCompilationStarted
            editorCompilationCompleted = jasmine.createSpy "editorCompilationCompleted"
            editorWorkerManager.__set__ "editorCompilationCompleted", editorCompilationCompleted
            editorCompilationFailed = jasmine.createSpy "editorCompilationFailed"
            editorWorkerManager.__set__ "editorCompilationFailed", editorCompilationFailed
            editorWorkerManager.__set__ "compilerUrl", "test compiler url"
            Worker = jasmine.createSpy "Worker"
            editorWorkerManager.__set__ "Worker", Worker
            workers = []
            Worker.and.callFake (src) ->
                (expect src).toEqual "test compiler url"
                data = 
                    instance: this
                    addEventListener: jasmine.createSpy "Worker.addEventListener"
                    terminate: jasmine.createSpy "Worker.terminate"
                    listeners: {}
                    postMessage: jasmine.createSpy "Worker.postMessage"
                this.addEventListener = data.addEventListener
                data.addEventListener.and.callFake (key, value) -> 
                    (expect this).toBe data.instance
                    data.listeners[key] = value
                    undefined
                this.terminate = data.terminate
                data.terminate.and.callFake -> (expect this).toBe data.instance
                this.postMessage = data.postMessage
                workers.push data
            editorWorkerManager.cancel()
        resetAll = ->
            editorCompilationStarted.calls.reset()
            editorCompilationCompleted.calls.reset()
            editorCompilationFailed.calls.reset()
        it "does not create any workers", -> (expect workers.length).toEqual 0
        it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
        describe "on calling cancel", ->
            beforeEach ->
                resetAll()
                element.value = "test code b"
                editorWorkerManager.cancel()
            it "does not create any workers", -> (expect workers.length).toEqual 0
            it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
            describe "on calling cancel", ->
                beforeEach ->
                    element.value = "test code c"
                    resetAll()
                    editorWorkerManager.cancel()
                it "does not create any workers", -> (expect workers.length).toEqual 0
                it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
            describe "on calling start", ->
                beforeEach ->
                    resetAll()
                    editorWorkerManager.start()
                it "creates one worker", -> (expect workers.length).toEqual 1
                it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                it "adds two event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                it "listens for the completion of the worker", -> (expect workers[0].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                it "listens for errors from the worker", -> (expect workers[0].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                it "posts one message to the worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                it "provides the worker with the code to compile", -> (expect workers[0].postMessage).toHaveBeenCalledWith "test code b"
                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                describe "on calling cancel", ->
                    beforeEach ->
                        element.value = "test code d"
                        resetAll()
                        editorWorkerManager.cancel()
                    it "does not create any workers", -> (expect workers.length).toEqual 1
                    it "terminates the worker", -> (expect workers[0].terminate).toHaveBeenCalled()
                    it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "does not post additional messages to the worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                    it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                    it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                    it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on calling start", ->
                        beforeEach ->
                            resetAll()
                            editorWorkerManager.start()
                        it "creates another worker", -> (expect workers.length).toEqual 2
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                        it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                        it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                        it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code d"
                        it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on calling cancel", ->
                            beforeEach ->
                                element.value = "test code e"
                                resetAll()
                                editorWorkerManager.cancel()
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "terminates the worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on encountering an error", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.error "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                            it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                        describe "on completing successfully", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.message "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                            it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                describe "on encountering an error", ->
                    beforeEach ->
                        resetAll()
                        workers[0].listeners.error "test event a"
                    it "does not create any workers", -> (expect workers.length).toEqual 1
                    it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                    it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                    it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                    it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                    it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event a"
                    describe "on calling cancel", ->
                        beforeEach ->
                            element.value = "test code f"
                            resetAll()
                            editorWorkerManager.cancel()
                        it "does not create any workers", -> (expect workers.length).toEqual 1
                        it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                        it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on calling start", ->
                            beforeEach ->
                                resetAll()
                                editorWorkerManager.start()
                            it "creates another worker", -> (expect workers.length).toEqual 2
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                            it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                            it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code f"
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                            describe "on calling cancel", ->
                                beforeEach ->
                                    element.value = "test code g"
                                    resetAll()
                                    editorWorkerManager.cancel()
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "terminates the new worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                            describe "on encountering an error", ->
                                beforeEach ->
                                    resetAll()
                                    workers[1].listeners.error "test event b"
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                                it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                                it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                            describe "on completing successfully", ->
                                beforeEach ->
                                    resetAll()
                                    workers[1].listeners.message "test event b"
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                                it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                                it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                describe "on completing successfully", ->
                    beforeEach ->
                        resetAll()
                        workers[0].listeners.message "test event a"
                    it "does not create any workers", -> (expect workers.length).toEqual 1
                    it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                    it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                    it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                    it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event a"
                    it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on calling cancel", ->
                        beforeEach ->
                            element.value = "test code h"
                            resetAll()
                            editorWorkerManager.cancel()
                        it "does not create any workers", -> (expect workers.length).toEqual 1
                        it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                        it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on calling start", ->
                            beforeEach ->
                                resetAll()
                                editorWorkerManager.start()
                            it "creates another worker", -> (expect workers.length).toEqual 2
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                            it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                            it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code h"
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                            describe "on calling cancel", ->
                                beforeEach ->
                                    element.value = "test code i"
                                    resetAll()
                                    editorWorkerManager.cancel()
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "terminates the new worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                            describe "on encountering an error", ->
                                beforeEach ->
                                    resetAll()
                                    workers[1].listeners.error "test event b"
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                                it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                                it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                            describe "on completing successfully", ->
                                beforeEach ->
                                    resetAll()
                                    workers[1].listeners.message "test event b"
                                it "does not create any workers", -> (expect workers.length).toEqual 2
                                it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                                it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                                it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                                it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                                it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                                it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                                it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
        describe "on calling start", ->
            beforeEach ->
                resetAll()
                editorWorkerManager.start()
            it "creates one worker", -> (expect workers.length).toEqual 1
            it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
            it "adds two event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
            it "listens for the completion of the worker", -> (expect workers[0].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
            it "listens for errors from the worker", -> (expect workers[0].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
            it "posts one message to the worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
            it "provides the worker with the code to compile", -> (expect workers[0].postMessage).toHaveBeenCalledWith "test code a"
            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
            describe "on calling cancel", ->
                beforeEach ->
                    element.value = "test code j"
                    resetAll()
                    editorWorkerManager.cancel()
                it "does not create any workers", -> (expect workers.length).toEqual 1
                it "terminates the worker", -> (expect workers[0].terminate).toHaveBeenCalled()
                it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                describe "on calling start", ->
                    beforeEach ->
                        resetAll()
                        editorWorkerManager.start()
                    it "creates another worker", -> (expect workers.length).toEqual 2
                    it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                    it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                    it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                    it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                    it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                    it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                    it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code j"
                    it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                    it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                    it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on calling cancel", ->
                        beforeEach ->
                            element.value = "test code k"
                            resetAll()
                            editorWorkerManager.cancel()
                        it "does not create any workers", -> (expect workers.length).toEqual 2
                        it "terminates the worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on encountering an error", ->
                        beforeEach ->
                            resetAll()
                            workers[1].listeners.error "test event b"
                        it "does not create any workers", -> (expect workers.length).toEqual 2
                        it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                        it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                    describe "on completing successfully", ->
                        beforeEach ->
                            resetAll()
                            workers[1].listeners.message "test event b"
                        it "does not create any workers", -> (expect workers.length).toEqual 2
                        it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                        it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                        it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
            describe "on encountering an error", ->
                beforeEach ->
                    resetAll()
                    workers[0].listeners.error "test event a"
                it "does not create any workers", -> (expect workers.length).toEqual 1
                it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event a"
                describe "on calling cancel", ->
                    beforeEach ->
                        element.value = "test code l"
                        resetAll()
                        editorWorkerManager.cancel()
                    it "does not create any workers", -> (expect workers.length).toEqual 1
                    it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                    it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                    it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                    it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on calling start", ->
                        beforeEach ->
                            resetAll()
                            editorWorkerManager.start()
                        it "creates another worker", -> (expect workers.length).toEqual 2
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                        it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                        it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                        it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code l"
                        it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on calling cancel", ->
                            beforeEach ->
                                element.value = "test code m"
                                resetAll()
                                editorWorkerManager.cancel()
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "terminates the new worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on encountering an error", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.error "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                            it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                        describe "on completing successfully", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.message "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                            it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
            describe "on completing successfully", ->
                beforeEach ->
                    resetAll()
                    workers[0].listeners.message "test event a"
                it "does not create any workers", -> (expect workers.length).toEqual 1
                it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event a"
                it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                describe "on calling cancel", ->
                    beforeEach ->
                        element.value = "test code n"
                        resetAll()
                        editorWorkerManager.cancel()
                    it "does not create any workers", -> (expect workers.length).toEqual 1
                    it "does not terminate the worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                    it "does not add further event listeners to the worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                    it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                    it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                    it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                    describe "on calling start", ->
                        beforeEach ->
                            resetAll()
                            editorWorkerManager.start()
                        it "creates another worker", -> (expect workers.length).toEqual 2
                        it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                        it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                        it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                        it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                        it "adds two event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                        it "listens for the completion of the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "message", jasmine.any Function
                        it "listens for errors from the worker", -> (expect workers[1].addEventListener).toHaveBeenCalledWith "error", jasmine.any Function
                        it "posts one message to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                        it "provides the new worker with the code to compile", -> (expect workers[1].postMessage).toHaveBeenCalledWith "test code n"
                        it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                        it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                        it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on calling cancel", ->
                            beforeEach ->
                                element.value = "test code o"
                                resetAll()
                                editorWorkerManager.cancel()
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "terminates the new worker", -> (expect workers[1].terminate).toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "calls editorCompilationStarted once", -> (expect editorCompilationStarted.calls.count()).toEqual 1
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()
                        describe "on encountering an error", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.error "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "does not call editorCompilationCompleted", -> (expect editorCompilationCompleted).not.toHaveBeenCalled()
                            it "calls editorCompilationFailed once", -> (expect editorCompilationFailed.calls.count()).toEqual 1
                            it "calls editorCompilationFailed with the event", -> (expect editorCompilationFailed).toHaveBeenCalledWith "test event b"
                        describe "on completing successfully", ->
                            beforeEach ->
                                resetAll()
                                workers[1].listeners.message "test event b"
                            it "does not create any workers", -> (expect workers.length).toEqual 2
                            it "does not terminate the old worker", -> (expect workers[0].terminate).not.toHaveBeenCalled()
                            it "does not terminate the new worker", -> (expect workers[1].terminate).not.toHaveBeenCalled()
                            it "does not add further event listeners to the old worker", -> (expect workers[0].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the old worker", -> (expect workers[0].postMessage.calls.count()).toEqual 1
                            it "does not add further event listeners to the new worker", -> (expect workers[1].addEventListener.calls.count()).toEqual 2
                            it "does not post additional messages to the new worker", -> (expect workers[1].postMessage.calls.count()).toEqual 1
                            it "does not call editorCompilationStarted", -> (expect editorCompilationStarted).not.toHaveBeenCalled()
                            it "calls editorCompilationCompleted once", -> (expect editorCompilationCompleted.calls.count()).toEqual 1
                            it "calls editorCompilationCompleted with the event", -> (expect editorCompilationCompleted).toHaveBeenCalledWith "test event b"
                            it "does not call editorCompilationFailed", -> (expect editorCompilationFailed).not.toHaveBeenCalled()