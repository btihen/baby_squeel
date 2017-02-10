require 'spec_helper'

describe BabySqueel::ActiveRecord::Calculations, '#summing' do
  let(:a1) { Author.create! age: 12 }
  let(:a2) { Author.create! age: 23 }

  before do
    [Post, Author].each(&:delete_all)
    Post.create! view_count: 1, author: a1
    Post.create! view_count: 2, author: a2
  end

  it 'sums attributes' do
    expect(Post.summing { view_count }).to eq(3)
  end

  it 'sums expressions' do
    expect(Post.summing { view_count + 1 }).to eq(5)
  end

  it 'sums associations' do
    expect(Post.joins(:author).summing { author.age }).to eq(35)
  end

  it 'sums group' do
    expect(Post.group(:author_id).summing { view_count }).to eq(
      a1.id => 1,
      a2.id => 2
    )
  end
end
