module Main where

import Chunk
import Debug

main :: IO ()
main = do
    let chunk0 = initChunk
    let chunk1 = writeChunk chunk0 OpConstant 123
    let chunk2 = addConstant chunk1 12
    let updatedChunk = writeChunk chunk2 OpReturn 123
    disassembleChunk updatedChunk "test"