import SheetDiagram from './sheet_diagram.js' ;

test('empty diagram', function() {
     let diag = new SheetDiagram([], []);
     expect(diag.nbVertices()).toEqual(0);
     expect(diag.nbEdges()).toEqual(0);
     expect(diag.nbEdgesAtLevel(0)).toEqual(0);
     expect(diag.serialize()).toEqual({inputs:[], slices:[]});
});

test('simple diagram', function() {
      let slices = [{
                offset:1,
                inputs:1,
                outputs:2,
                nodes: [
                   {
                      offset: 0,
                      inputs: [1],
                      outputs: [1,1]
                   }
                ]
              },
              {
                 offset:2,
                 inputs:2,
                 outputs:2,
                 nodes: [
                   {
                      offset: 0,
                      inputs: [2, 2],
                      outputs: [1, 1]
                   }
                ]
              }];
      let diag = new SheetDiagram([ 1, 2, 2], slices);
      expect(diag.getVertex(0)).toEqual(slices[0]);
      expect(diag.getVertex(1)).toEqual(slices[1]);
      expect(diag.getPathsOnEdge(0)).toEqual([[0,0]]);
      expect(diag.getPathsOnEdge(1)).toEqual([[0,0],[1,1]]);
      expect(diag.getPathsOnEdge(2)).toEqual([[0,0],[1,0]]);
      expect(diag.getPathsOnEdge(3)).toEqual([[0,0],[1,1]]);
      expect(diag.getPathsOnEdge(4)).toEqual([[0,0],[1,0]]);
      expect(diag.getPathsOnEdge(5)).toEqual([[0,0]]);
      expect(diag.getPathsOnEdge(6)).toEqual([[0,0]]);
        
      expect(diag.getIncomingPaths(0, 0)).toEqual([[1,0]]);
      expect(diag.getIncomingPaths(0, 1)).toEqual([[1,1]]);
      expect(diag.getOutgoingPaths(0, 0)).toEqual([[3,0],[4,0]]);
      expect(diag.getOutgoingPaths(0, 1)).toEqual([[3,1],[4,1]]);
      expect(diag.getIncomingPaths(1, 0)).toEqual([[4,0],[4,1],[2,0],[2,1]]);
      expect(diag.getOutgoingPaths(1, 0)).toEqual([[5,0],[6,0]]);

      expect(diag.nbNodesOnVertex(0)).toEqual(2);
      expect(diag.nbNodesOnVertex(1)).toEqual(1);

      expect(diag.getNode(0,0)).toEqual({ offset: 0, inputs: [1], outputs: [1,1] });
      expect(diag.getNode(0,1)).toEqual(undefined);
      expect(diag.getNode(1,0)).toEqual({ offset: 0, inputs: [2,2], outputs: [1,1] });
});

test('tensor product', function() {
      let slices = [{
        offset: 0,
        inputs: 4,
        outputs: 4,
        nodes: [
          {
             offset: 1,
             inputs: [1,1,1,1],
             outputs: [1,1,1,1]
          },
          {
             offset: 0,
             inputs: [1,1,1,1],
             outputs: [1,1,1,1]
          }
        ]
      }];
     let diag = new SheetDiagram([4,4,4,4], slices);
     expect(diag.getPathsOnEdge(0)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(1)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(2)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(3)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(4)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(5)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(6)).toEqual([[0,0],[1,1],[2,2],[3,3]]);
     expect(diag.getPathsOnEdge(7)).toEqual([[0,0],[1,1],[2,2],[3,3]]);

     expect(diag.getIncomingPaths(0, 0)).toEqual([[0,0],[1,0],[2,0],[3,0]]);
     expect(diag.getIncomingPaths(0, 1)).toEqual([[0,1],[1,1],[2,1],[3,1]]);
     expect(diag.getIncomingPaths(0, 2)).toEqual([[0,2],[1,2],[2,2],[3,2]]);
     expect(diag.getIncomingPaths(0, 3)).toEqual([[0,3],[1,3],[2,3],[3,3]]);
     expect(diag.getOutgoingPaths(0, 0)).toEqual([[4,0],[5,0],[6,0],[7,0]]);
     expect(diag.getOutgoingPaths(0, 1)).toEqual([[4,1],[5,1],[6,1],[7,1]]);
     expect(diag.getOutgoingPaths(0, 2)).toEqual([[4,2],[5,2],[6,2],[7,2]]);
     expect(diag.getOutgoingPaths(0, 3)).toEqual([[4,3],[5,3],[6,3],[7,3]]);

     expect(diag.nbNodesOnVertex(0)).toEqual(4);
});

test('hadamard', function() {
     let slices = [{
        offset: 0,
        inputs: 1,
        outputs: 2,
        nodes: [
           {
              offset: 0,
              inputs: [1],
              outputs: [0,0]
           }
        ]
     },
     {
        offset: 0,
        inputs: 2,
        outputs: 1,
        nodes: [
           {
               offset: 0,
               inputs: [0,0],
               outputs: [1]
           }
       ]
    }];
    let diag = new SheetDiagram([1], slices);
    expect(diag.getPathsOnEdge(0)).toEqual([[0,0]]);
    expect(diag.getPathsOnEdge(1)).toEqual([]);
    expect(diag.getPathsOnEdge(2)).toEqual([]);
    expect(diag.getPathsOnEdge(3)).toEqual([[0,0]]);

    expect(diag.getIncomingPaths(0, 0)).toEqual([[0,0]]);
    expect(diag.getOutgoingPaths(0, 0)).toEqual([]);
    expect(diag.getIncomingPaths(1, 0)).toEqual([]);
    expect(diag.getOutgoingPaths(1, 0)).toEqual([[3,0]]);

    expect(diag.nbNodesOnVertex(0)).toEqual(1);
    expect(diag.nbNodesOnVertex(1)).toEqual(1);
});

test('controlled swap', function() {
    let slices = [
    {
        offset: 0,
        inputs: 1,
        outputs: 2,
        nodes: [{ offset: 0, inputs: [1], outputs: [0,0]}]
    },
    {
        offset: 1,
        inputs: 1,
        outputs: 2,
        nodes: [{
           offset: 0, inputs: [1], outputs: [0,0]
        }]
    },
    {
        swap: 1
    },
   {
        offset: 1,
        inputs: 2,
        outputs: 1,
        nodes: [{ offset: 0, inputs: [0,0], outputs: [1]}]
    },
    {
        offset: 0,
        inputs: 2,
        outputs: 1,
        nodes: [{
           offset: 0, inputs: [0,0], outputs: [1]
        }]
    }
    ];
    let diag = new SheetDiagram([2], slices);
    
    expect(diag.nbNodesOnVertex(0)).toEqual(2);
    expect(diag.nbNodesOnVertex(1)).toEqual(1);
    expect(diag.nbNodesOnVertex(2)).toEqual(0);
    expect(diag.nbNodesOnVertex(3)).toEqual(1);
    expect(diag.nbNodesOnVertex(4)).toEqual(2);
    expect(diag.isSwapVertex(0)).toEqual(false);
    expect(diag.isSwapVertex(1)).toEqual(false);
    expect(diag.isSwapVertex(2)).toEqual(true);
    expect(diag.isSwapVertex(3)).toEqual(false);
    expect(diag.isSwapVertex(4)).toEqual(false);
});

test('binding nodes on swap', function() {
    let diag = new SheetDiagram([2,3], [{swap: 0}]);
    
    expect(diag.isSwapVertex(0)).toEqual(true);
    expect(diag.nbNodesOnVertex(0)).toEqual(2+3);
    expect(diag.getIncomingPaths(0, 0)).toEqual([[0,0]]);
    expect(diag.getIncomingPaths(0, 1)).toEqual([[0,1]]);
    expect(diag.getIncomingPaths(0, 2)).toEqual([[1,0]]);
    expect(diag.getIncomingPaths(0, 3)).toEqual([[1,1]]);
    expect(diag.getIncomingPaths(0, 4)).toEqual([[1,2]]);
    expect(diag.getOutgoingPaths(0, 0)).toEqual([[3,0]]);
    expect(diag.getOutgoingPaths(0, 1)).toEqual([[3,1]]);
    expect(diag.getOutgoingPaths(0, 2)).toEqual([[2,0]]);
    expect(diag.getOutgoingPaths(0, 3)).toEqual([[2,1]]);
    expect(diag.getOutgoingPaths(0, 4)).toEqual([[2,2]]);
    expect(diag.getNode(0, 0)).toEqual(undefined);
    expect(diag.getNode(0, 1)).toEqual(undefined);
    expect(diag.getNode(0, 2)).toEqual(undefined);
    expect(diag.getNode(0, 3)).toEqual(undefined);
    expect(diag.getNode(0, 4)).toEqual(undefined);
});

test('inconsistent numbers of edges on joined sheets', function() {
    let slices = [{
        offset: 0,
        inputs: 2,
        outputs: 0,
        nodes: []
    }];
    expect(function() { new SheetDiagram([2,1], slices)})
        .toThrow('Joining up sheets with inconsistent numbers of wires on them, at slice 0');
});

test('not enough edges on sheet, for node inputs', function() {
    let slices = [{
        offset: 0,
        inputs: 1,
        outputs: 1,
        nodes: [
           {
              offset: 0,
              inputs: [2],
              outputs: [2],
           }
        ]
    }];
    expect(function() { new SheetDiagram([1], slices) })
        .toThrow('Not enough wires on input sheet 0 at slice 0');
});

test('not enough edges on sheet, for offsets', function() {
    let slices = [{
        offset: 0,
        inputs: 1,
        outputs: 1,
        nodes: [
           {
              offset: 4,
              inputs: [0],
              outputs: [0],
           }
        ]
    }];
    expect(function() { new SheetDiagram([1], slices) })
        .toThrow('Not enough wires on input sheet 0 at slice 0');
});

test('not enough input sheets', function() {
   let diagram = {
    inputs: [ 1 ],
    slices: [
        {
            offset: 1,
            inputs: 1,
            outputs: 2,
        }
      ]
   };
   expect(function() { SheetDiagram.deserialize(diagram) })
        .toThrow('Not enough input wires at slice 0');
});

test('serialize swap', function() {
    let diag = {
        "inputs": [ 2 ],
        "slices": [
            {
                "offset": 0,
                "inputs": 1,
                "outputs": 2,
                "nodes": [
                    {
                        "offset": 0,
                        "inputs": [ 1 ],
                        "outputs": [ 0, 0 ]
                    }
                ]
            },
            {
                "offset": 1,
                "inputs": 1,
                "outputs": 2,
                "nodes": [
                    {
                        "offset": 0,
                        "inputs": [ 1 ],
                        "outputs": [ 0, 0 ]
                    }
                ]
            },
            {
                "swap": 1
            },
            {
                "offset": 1,
                "inputs": 2,
                "outputs": 1,
                "nodes": [
                    {
                        "offset": 0,
                        "inputs": [ 0, 0 ],
                        "outputs": [ 1 ]
                    }
                ]
            },
            {
                "offset": 0,
                "inputs": 2,
                "outputs": 1,
                "nodes": [
                    {
                        "offset": 0,
                        "inputs": [ 0, 0 ],
                        "outputs": [ 1 ]
                    }
                ]
            }
        ]
    };
    expect(SheetDiagram.deserialize(diag).serialize()).toEqual(diag);
});

test('diagram annotations', function() {
      let slices = [{
                offset:1,
                inputs:1,
                outputs:2,
                nodes: [
                   {
                      offset: 0,
                      inputs: [1],
                      outputs: [1,1],
                      label: "$f$"
                   }
                ]
              },
              {
                 offset:2,
                 inputs:2,
                 outputs:2,
                 nodes: [
                   {
                      offset: 0,
                      inputs: [2, 2],
                      outputs: [1, 1],
                      label: "$g$"
                   }
                ]
              }];
      let diag = new SheetDiagram([ ["A"], ["B","C"], 2], slices, [ ["A"], ["X", "Y"], 1, 1]);

      expect(diag.getNode(0,0)).toEqual({ offset: 0, inputs: [1], outputs: [1,1], label: "$f$"});
      expect(diag.getNode(0,1)).toEqual(undefined);
      expect(diag.getNode(1,0)).toEqual({ offset: 0, inputs: [2,2], outputs: [1,1], label: "$g$" });
      expect(diag.getDomainLabel(0, 0)).toEqual("A");
      expect(diag.getDomainLabel(1, 0)).toEqual("B");
      expect(diag.getDomainLabel(1, 1)).toEqual("C");
      expect(diag.getDomainLabel(2, 0)).toEqual(undefined);
      expect(diag.getDomainLabel(2, 1)).toEqual(undefined);
      expect(diag.getCodomainLabel(0,0)).toEqual("A");
      expect(diag.getCodomainLabel(1,0)).toEqual("X");
      expect(diag.getCodomainLabel(1,1)).toEqual("Y");
      expect(diag.getCodomainLabel(1,2)).toEqual(undefined);
      expect(diag.getCodomainLabel(2,0)).toEqual(undefined);
      expect(diag.serialize().outputs[1][0]).toEqual("X");
});


