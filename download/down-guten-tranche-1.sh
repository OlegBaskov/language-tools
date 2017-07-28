#
# Download and prep a bunch of texts from project gutenberg,
# and prep them for language-learning for English.  These titles
# comprise most of the "tranche-1" series of parsed texts.

destination="../../text/en-tranche-1"
mkdir -p $destination

wget http://www.gutenberg.org/files/76/76-0.txt
./cleanup_book.sh 76-0.txt $destination/huck-finn.txt

wget http://www.gutenberg.org/ebooks/5200.txt.utf-8
./cleanup_book.sh 5200.txt.utf-8 $destination/kafka.txt

wget http://www.gutenberg.org/ebooks/1661.txt.utf-8
./cleanup_book.sh 1661.txt.utf-8 $destination/sherlock.txt

wget http://www.gutenberg.org/files/2701/2701-0.txt
./cleanup_book.sh 2701-0.txt $destination/moby-dick.txt

wget http://www.gutenberg.org/ebooks/345.txt.utf-8
./cleanup_book.sh 345.txt.utf-8 $destination/dracula.txt

wget http://www.gutenberg.org/files/2591/2591-0.txt
./cleanup_book.sh 2591-0.txt $destination/grimm.txt

wget http://www.gutenberg.org/files/1400/1400-0.txt
./cleanup_book.sh 1400-0.txt $destination/expect.txt

wget http://www.gutenberg.org/files/158/158-0.txt
./cleanup_book.sh 158-0.txt $destination/emma.txt

wget http://www.gutenberg.org/ebooks/30254.txt.utf-8
./cleanup_book.sh 30254.txt.utf-8 $destination/lust.txt

wget http://www.gutenberg.org/files/28054/28054-0.txt
./cleanup_book.sh 28054-0.txt $destination/karamozov.txt

wget http://www.gutenberg.org/ebooks/408.txt.utf-8
./cleanup_book.sh 408.txt.utf-8 $destination/dubois.txt

wget http://www.gutenberg.org/ebooks/20203.txt.utf-8
./cleanup_book.sh 20203.txt.utf-8 $destination/franklin.txt

wget http://www.gutenberg.org/files/203/203-0.txt
./cleanup_book.sh 203-0.txt $destination/uncle-tom.txt

wget http://www.gutenberg.org/ebooks/833.txt.utf-8
./cleanup_book.sh 833.txt.utf-8 $destination/veblen.txt

wget http://www.gutenberg.org/files/140/140-0.txt
./cleanup_book.sh 140-0.txt $destination/jungle.txt

wget http://www.gutenberg.org/ebooks/145.txt.utf-8
./cleanup_book.sh 145.txt.utf-8 $destination/middlemarch.txt

wget http://www.gutenberg.org/files/54585/54585-0.txt
./cleanup_book.sh 54585-0.txt $destination/venus.txt

wget http://www.gutenberg.org/ebooks/1524.txt.utf-8
./cleanup_old_book.sh 1524.txt.utf-8 $destination/hamlet.txt

wget http://www.gutenberg.org/ebooks/21279.txt.utf-8
./cleanup_book.sh 21279.txt.utf-8 $destination/vonn.txt

wget http://www.gutenberg.org/ebooks/7142.txt.utf-8
./cleanup_book.sh 7142.txt.utf-8 $destination/pelop.txt

wget http://www.gutenberg.org/files/18269/18269-0.txt
./cleanup_book.sh 18269-0.txt $destination/pascal.txt

wget http://www.gutenberg.org/files/155/155-0.txt
./cleanup_book.sh 155-0.txt $destination/moonstone.txt

wget http://www.gutenberg.org/files/54591/54591-0.txt
./cleanup_book.sh 54591-0.txt $destination/japan.txt

wget http://www.gutenberg.org/files/5225/5225-0.txt
./cleanup_book.sh 5225-0.txt $destination/satyr.txt

wget http://www.gutenberg.org/files/54579/54579-0.txt
./cleanup_book.sh 54579-0.txt $destination/aero.txt

wget http://www.gutenberg.org/files/54613/54613-0.txt
./cleanup_book.sh 54613-0.txt $destination/khe.txt

wget http://www.gutenberg.org/ebooks/45631.txt.utf-8
./cleanup_book.sh 45631.txt.utf-8 $destination/slave.txt

wget http://www.gutenberg.org/ebooks/22657.txt.utf-8
./cleanup_book.sh 22657.txt.utf-8 $destination/steam.txt

wget http://www.gutenberg.org/ebooks/8164.txt.utf-8
./cleanup_book.sh 8164.txt.utf-8 $destination/jeeves.txt

wget http://www.gutenberg.org/files/940/940-0.txt
./cleanup_book.sh 940-0.txt $destination/mohicans.txt

wget http://www.gutenberg.org/ebooks/31547.txt.utf-8
./cleanup_book.sh 31547.txt.utf-8 $destination/youth.txt

wget http://www.gutenberg.org/ebooks/851.txt.utf-8
./cleanup_book.sh 851.txt.utf-8 $destination/rowland.txt

wget http://www.gutenberg.org/ebooks/7452.txt.utf-8
./cleanup_book.sh 7452.txt.utf-8 $destination/yogi.txt

wget http://www.gutenberg.org/files/54545/54545-0.txt
./cleanup_book.sh 54545-0.txt $destination/century.txt

wget http://www.gutenberg.org/files/54634/54634-0.txt
./cleanup_book.sh 54634-0.txt $destination/majorca.txt

wget http://www.gutenberg.org/ebooks/2166.txt.utf-8
./cleanup_book.sh 2166.txt.utf-8 $destination/mines.txt

wget http://www.gutenberg.org/ebooks/2009.txt.utf-8
./cleanup_book.sh 2009.txt.utf-8 $destination/darwin.txt

wget http://www.gutenberg.org/files/208/208-0.txt
./cleanup_book.sh 208-0.txt $destination/daisy.txt

wget http://www.gutenberg.org/ebooks/54665.txt.utf-8
./cleanup_book.sh 54665.txt.utf-8 $destination/psychic.txt

wget http://www.gutenberg.org/ebooks/599.txt.utf-8
./cleanup_book.sh 599.txt.utf-8 $destination/vanity.txt

wget http://www.gutenberg.org/ebooks/11224.txt.utf-8
./cleanup_book.sh 11224.txt.utf-8 $destination/util.txt

wget http://www.gutenberg.org/ebooks/15210.txt.utf-8
./cleanup_book.sh 15210.txt.utf-8 $destination/darkwater.txt

wget http://www.gutenberg.org/files/16769/16769-0.txt
./cleanup_book.sh 16769-0.txt $destination/orthodoxy.txt

wget http://www.gutenberg.org/files/54710/54710-0.txt
./cleanup_book.sh 54710-0.txt $destination/shame.txt

wget http://www.gutenberg.org/ebooks/621.txt.utf-8
./cleanup_book.sh 621.txt.utf-8 $destination/relig.txt

wget http://www.gutenberg.org/ebooks/8438.txt.utf-8
./cleanup_book.sh 8438.txt.utf-8 $destination/ethics.txt

wget http://www.gutenberg.org/files/2892/2892-0.txt
./cleanup_book.sh 2892-0.txt $destination/irish.txt

wget http://www.gutenberg.org/ebooks/6519.txt.utf-8
./cleanup_book.sh 6519.txt.utf-8 $destination/kabir.txt

wget http://www.gutenberg.org/ebooks/29558.txt.utf-8
./cleanup_book.sh 29558.txt.utf-8 $destination/scouts.txt

wget http://www.gutenberg.org/ebooks/5720.txt.utf-8
./cleanup_book.sh 5720.txt.utf-8 $destination/shrop.txt

wget http://www.gutenberg.org/ebooks/45502.txt.utf-8
./cleanup_book.sh 45502.txt.utf-8 $destination/other-half.txt

wget http://www.gutenberg.org/files/8147/8147-0.txt
./cleanup_book.sh 8147-0.txt $destination/kip-king.txt

wget http://www.gutenberg.org/files/54712/54712-0.txt
./cleanup_book.sh 54712-0.txt $destination/penny.txt
