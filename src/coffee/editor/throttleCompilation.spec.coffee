describe "editor", -> describe "throttleCompilation", ->
    rewire = require "rewire"
    describe "imports", ->
        editorThrottleCompilation = rewire "./throttleCompilation"
        it "editorWorkerManager", -> (expect editorThrottleCompilation.__get__ "editorWorkerManager").toBe require "./workerManager"
    describe "on calling", ->
        editorThrottleCompilation = editorWorkerManagerStart = editorWorkerManagerCancel = setTimeout = clearTimeout = undefined
        beforeEach ->
            editorThrottleCompilation = rewire "./throttleCompilation"
            editorWorkerManagerCancel = jasmine.createSpy "editorWorkerManager.cancel"
            editorWorkerManagerStart = jasmine.createSpy "editorWorkerManager.start"
            editorThrottleCompilation.__set__ "editorWorkerManager",
                cancel: editorWorkerManagerCancel
                start: editorWorkerManagerStart
            setTimeout = jasmine.createSpy "setTimeout"
            calls = 0
            setTimeout.and.callFake -> "test timeout #{calls++}"
            editorThrottleCompilation.__set__ "setTimeout", setTimeout
            clearTimeout = jasmine.createSpy "clearTimeout"
            editorThrottleCompilation.__set__ "clearTimeout", clearTimeout
            editorThrottleCompilation()
        resetAll = ->
            editorWorkerManagerStart.calls.reset()
            editorWorkerManagerCancel.calls.reset()
            setTimeout.calls.reset()
            clearTimeout.calls.reset()
        it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
        it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
        it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
        it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
        it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
        describe "on calling again", ->
            beforeEach ->
                resetAll()
                editorThrottleCompilation()
            it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
            it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
            it "clears one timeout", -> (expect clearTimeout.calls.count()).toEqual 1
            it "clears the previously created timeout", -> (expect clearTimeout).toHaveBeenCalledWith "test timeout 0"
            it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
            it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
            describe "on calling again", ->
                beforeEach ->
                    resetAll()
                    editorThrottleCompilation()
                it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
                it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
                it "clears one timeout", -> (expect clearTimeout.calls.count()).toEqual 1
                it "clears the previously created timeout", -> (expect clearTimeout).toHaveBeenCalledWith "test timeout 1"
                it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
                it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
                describe "on calling again", ->
                    beforeEach ->
                        resetAll()
                        editorThrottleCompilation()
                    it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
                    it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
                    it "clears one timeout", -> (expect clearTimeout.calls.count()).toEqual 1
                    it "clears the previously created timeout", -> (expect clearTimeout).toHaveBeenCalledWith "test timeout 2"
                    it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
                    it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
                describe "on completing", ->
                    beforeEach ->
                        callback = (setTimeout.calls.argsFor 0)[0]
                        resetAll()
                        callback()
                    it "does not call editorWorkerManager.cancel", -> (expect editorWorkerManagerCancel).not.toHaveBeenCalled()
                    it "calls editorWorkerManager.start once", -> (expect editorWorkerManagerStart.calls.count()).toEqual 1
                    it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
                    it "does not set any timeouts", -> (expect setTimeout).not.toHaveBeenCalled()
            describe "on completing", ->
                beforeEach ->
                    callback = (setTimeout.calls.argsFor 0)[0]
                    resetAll()
                    callback()
                it "does not call editorWorkerManager.cancel", -> (expect editorWorkerManagerCancel).not.toHaveBeenCalled()
                it "calls editorWorkerManager.start once", -> (expect editorWorkerManagerStart.calls.count()).toEqual 1
                it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
                it "does not set any timeouts", -> (expect setTimeout).not.toHaveBeenCalled()
                describe "on calling again", ->
                    beforeEach ->
                        resetAll()
                        editorThrottleCompilation()
                    it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
                    it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
                    it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
                    it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
                    it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
        describe "on completing", ->
            beforeEach ->
                callback = (setTimeout.calls.argsFor 0)[0]
                resetAll()
                callback()
            it "does not call editorWorkerManager.cancel", -> (expect editorWorkerManagerCancel).not.toHaveBeenCalled()
            it "calls editorWorkerManager.start once", -> (expect editorWorkerManagerStart.calls.count()).toEqual 1
            it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
            it "does not set any timeouts", -> (expect setTimeout).not.toHaveBeenCalled()
            describe "on calling again", ->
                beforeEach ->
                    resetAll()
                    editorThrottleCompilation()
                it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
                it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
                it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
                it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
                it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
                describe "on calling again", ->
                    beforeEach ->
                        resetAll()
                        editorThrottleCompilation()
                    it "calls editorWorkerManager.cancel once", -> (expect editorWorkerManagerCancel.calls.count()).toEqual 1
                    it "does not call editorWorkerManager.start", -> (expect editorWorkerManagerStart).not.toHaveBeenCalled()
                    it "clears one timeout", -> (expect clearTimeout.calls.count()).toEqual 1
                    it "clears the previously created timeout", -> (expect clearTimeout).toHaveBeenCalledWith "test timeout 1"
                    it "sets one timeout", -> (expect setTimeout.calls.count()).toEqual 1
                    it "sets a delay of 250msec", -> (expect (setTimeout.calls.argsFor 0)[1]).toEqual 250
                describe "on completing", ->
                    beforeEach ->
                        callback = (setTimeout.calls.argsFor 0)[0]
                        resetAll()
                        callback()
                    it "does not call editorWorkerManager.cancel", -> (expect editorWorkerManagerCancel).not.toHaveBeenCalled()
                    it "calls editorWorkerManager.start once", -> (expect editorWorkerManagerStart.calls.count()).toEqual 1
                    it "does not clear any timeouts", -> (expect clearTimeout).not.toHaveBeenCalled()
                    it "does not set any timeouts", -> (expect setTimeout).not.toHaveBeenCalled()