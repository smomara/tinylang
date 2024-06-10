module Debug where

import Text.Printf (printf)

import Chunk

disassembleChunk :: Chunk -> String -> IO ()
disassembleChunk chunk name = do
    putStrLn $ "== " ++ name ++ " =="
    disassembleInstructions chunk 0 0

disassembleInstructions :: Chunk -> Int -> Int -> IO ()
disassembleInstructions chunk offset lineIdx
  | offset >= length (code chunk) = return ()
  | otherwise = do
    let op = code chunk !! offset
    let LineInfo line count = lineNumbers chunk !! lineIdx
    case op of
      OpConstant -> do
        let constant = constants chunk !! offset
        putStrLn $ printf "%4d %4d %-16s %4d" line offset (show op) constant
        disassembleInstructions chunk (offset + 1) (if count > 1 then lineIdx else lineIdx + 1)
      _ -> do
        putStrLn $ printf "%4d %4d %-16s" line offset (show op)
        disassembleInstructions chunk (offset + 1) (if count > 1 then lineIdx else lineIdx + 1)