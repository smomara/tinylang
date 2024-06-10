module Chunk where

data OpCode
    = OpConstant
    | OpReturn
    deriving (Show, Enum)

data LineInfo = LineInfo {
    lineNumber :: Int,
    count :: Int
}

data Chunk = Chunk {
    code :: [OpCode],
    constants :: [Int],
    lineNumbers :: [LineInfo]
}

initChunk :: Chunk
initChunk = Chunk [] [] []

updateLineNumbers :: Chunk -> Int -> [LineInfo]
updateLineNumbers chunk line =
    let existingLines = lineNumbers chunk
    in case existingLines of
        [] -> [LineInfo line 1]
        (LineInfo currentLine count : xs) ->
            if currentLine == line
                then LineInfo currentLine (count + 1) : xs
                else LineInfo line 1 : existingLines

writeChunk :: Chunk -> OpCode -> Int -> Chunk
writeChunk chunk opcode line = chunk {
    code = code chunk ++ [opcode],
    lineNumbers = updateLineNumbers chunk line
    }

addConstant :: Chunk -> Int -> Chunk
addConstant chunk value = chunk {
    constants = constants chunk ++ [value]
}