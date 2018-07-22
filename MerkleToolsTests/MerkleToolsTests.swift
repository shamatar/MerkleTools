//
//  MerkleToolsTests.swift
//  MerkleToolsTests
//
//  Created by Alexander Vlasov on 22.07.2018.
//  Copyright © 2018 Alexander Vlasov. All rights reserved.
//

import XCTest
@testable import MerkleTools

class MerkleToolsTests: XCTestCase {
    
    func testSimpleTree() {
        let content0 = SimpleContent(Data(repeating: 0, count: 32))
        let content1 = SimpleContent(Data(repeating: 1, count: 32))
        let content2 = SimpleContent(Data(repeating: 2, count: 32))
        let padding = SimpleContent(Data(repeating: 255, count: 32))
        let tree = PaddabbleTree([content0, content1, content2], padding)
        XCTAssert(tree.merkleRoot != nil)
        
        print((tree.content[0] as! TreeNode).description)
        print((tree.content[0].parent! as! TreeNode).description)
        print((tree.content[0].parent!.parent! as! TreeNode).description)
        
        let root = tree.merkleRoot!
        print("Root = " + root.toHexString())
        let proof0 = tree.makeBinaryProof(0)
        XCTAssert(proof0 != nil)
        XCTAssert(proof0!.count == 66)
        let included0 = PaddabbleTree.verifyBinaryProof(content: content0, proof: proof0!, expectedRoot: root)
        XCTAssert(included0)
        
        let proof1 = tree.makeBinaryProof(1)
        XCTAssert(proof1 != nil)
        XCTAssert(proof1!.count == 66)
        let included1 = PaddabbleTree.verifyBinaryProof(content: content1, proof: proof1!, expectedRoot: root)
        XCTAssert(included1)
        
        let proof2 = tree.makeBinaryProof(2)
        XCTAssert(proof2 != nil)
        XCTAssert(proof2!.count == 66)
        let included2 = PaddabbleTree.verifyBinaryProof(content: content2, proof: proof2!, expectedRoot: root)
        XCTAssert(included2)
        
        let proofP = tree.makeBinaryProof(3)
        XCTAssert(proofP == nil)
        
        let notIncluded = PaddabbleTree.verifyBinaryProof(content: content0, proof: proof1!, expectedRoot: root)
        XCTAssert(!notIncluded)
    }
}
